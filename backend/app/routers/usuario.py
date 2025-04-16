from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..schemas import AnalisisCromaticoIn
from .. import schemas, crud, database, models  
from ..schemas import UsuarioCreate, UsuarioOut
from.. schemas import UsuarioLogin
from fastapi import APIRouter, File, UploadFile, Depends, HTTPException
from sqlalchemy.orm import Session
from app.utils.s3_upload import upload_image_to_s3
from PIL import Image
import torch
from torchvision import transforms
from app.modelos.modelo_skin import SkinTypeClassifier
import random


router = APIRouter(
    prefix="/usuarios",
    tags=["Usuarios"]
)

@router.post("/", response_model=UsuarioOut, status_code=status.HTTP_201_CREATED)
def create_usuario(usuario: UsuarioCreate, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.create_usuario(db, usuario)

@router.get("/", response_model=List[UsuarioOut])
def read_usuarios(db: Session = Depends(database.get_db)):
    return crud.crud_usuario.get_usuarios(db)

@router.get("/{usuario_id}", response_model=UsuarioOut)
def read_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.get_usuario(db, usuario_id)

@router.put("/{usuario_id}", response_model=UsuarioOut)
def update_usuario(usuario_id: int, usuario_update: UsuarioCreate, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.update_usuario(db, usuario_id, usuario_update)

@router.delete("/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.delete_usuario(db, usuario_id)

@router.post("/login")
def login(usuario: UsuarioLogin, db: Session = Depends(database.get_db)):
    # Verificar si el usuario existe en la base de datos
    # y si la contraseña es correcta
    user = db.query(models.Usuario).filter_by(email=usuario.email, contrasena=usuario.contrasena).first()
    if not user:
        raise HTTPException(status_code=400, detail="Correo o contraseña incorrectos")
    return {"message": "Inicio de sesión exitoso", "usuario_id": user.id_usuario}


# Cargar modelo una vez
modelo = SkinTypeClassifier()
modelo.load_state_dict(torch.load("app/modelos/skin_type_model.pt", map_location=torch.device("cpu")))
modelo.eval()

# Mapeo de clases
label_mapping = {
    0: 'Tipo_I',
    1: 'Tipo_II',
    2: 'Tipo_III',
    3: 'Tipo_IV',
    4: 'Tipo_V',
    5: 'Tipo_VI'
}

# Transformación imagen
val_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

@router.post("/{usuario_id}/analisis-cromatico")
async def analizar_y_guardar(
    usuario_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(database.get_db)
):
    # 1. Validar que el usuario exista
    usuario = db.query(models.Usuario).filter(models.Usuario.id_usuario == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")

    # 2. Cargar imagen y aplicar transformación
    image = Image.open(file.file).convert("RGB")
    tensor = val_transform(image).unsqueeze(0)

    # 3. Predicción
    with torch.no_grad():
        output = modelo(tensor)
        pred = torch.argmax(output, dim=1).item()
        tipo_piel = label_mapping[pred]

    # 4. Subida a S3
    file.file.seek(0)  # Reiniciar el puntero del archivo
    image_url = upload_image_to_s3(file, usuario_id, folder="users")

    # 5. Guardar en la base de datos
    usuario.tono_piel = tipo_piel
    usuario.foto_url = image_url
    db.commit()

    return {
        "message": "Análisis cromático realizado y guardado",
        "tono_piel": tipo_piel,
        "foto_url": image_url
    }