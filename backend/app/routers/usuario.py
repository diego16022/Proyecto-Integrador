from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..schemas import AnalisisCromaticoIn
from .. import schemas, crud, database, models  
from ..schemas import UsuarioCreate, UsuarioOut
from.. schemas import UsuarioLogin
from fastapi import APIRouter, File, UploadFile, Depends, HTTPException
from sqlalchemy.orm import Session
from app.utils.s3_upload import upload_image_to_s3, upload_base64_image_to_s3
from PIL import Image
import torch
from torchvision import transforms
from app.modelos.modelo_skin import SkinTypeClassifier
import random
import requests



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


def obtener_tono_piel_desde_api(file: UploadFile) -> dict:
    url = "http://52.14.66.242:8000/predict"  # IP pública de EC2
    response = requests.post(url, files={"file": (file.filename, file.file, file.content_type)})
    if response.status_code == 200:
        return response.json()
    else:
        raise HTTPException(status_code=500, detail=f"Error al predecir tono de piel: {response.text}")

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

    # 2. Predecir tono de piel desde el microservicio
    resultado = obtener_tono_piel_desde_api(file)
    tono_piel = resultado["descripcion"]
    rostro_base64 = resultado["rostro_base64"]

    # 3. Subida a S3
    file.file.seek(0)  # Reiniciar el puntero del archivo
    image_url = upload_image_to_s3(file, usuario_id, folder="users")

    # 4. Subida del rostro recortado a S3
    recorte_url = upload_base64_image_to_s3(rostro_base64, usuario_id, folder="users/recortes")

    # 5. Guardar en la base de datos
    usuario.tono_piel = tono_piel
    usuario.foto_url = image_url
    db.commit()


    return {
        "message": "Análisis cromático realizado y guardado",
        "tono_piel": tono_piel,
        "foto_url": image_url,
        "rostro_url": recorte_url
    }
