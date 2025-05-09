from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database
from ..models import Prenda_Ocasion
from ..crud import crud_prenda
from fastapi import UploadFile, File
from ..schemas import PrendaCreate
from ..crud import crud_prenda
from ..database import get_db
from app.utils.s3_upload import upload_image_to_s3
from fastapi import Form


router = APIRouter(
    prefix="/prendas",
    tags=["Prendas"]
)

@router.post("/", response_model=schemas.PrendaOut, status_code=status.HTTP_201_CREATED)
def create_prenda(prenda: schemas.PrendaCreate, db: Session = Depends(database.get_db)):
    return crud.crud_prenda.create_prenda(db, prenda)

@router.get("/", response_model=List[schemas.PrendaOut])
def read_prendas(db: Session = Depends(database.get_db)):
    return crud.crud_prenda.get_prendas(db)

@router.get("/{prenda_id}", response_model=schemas.PrendaOut)
def read_prenda(prenda_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_prenda.get_prenda(db, prenda_id)

@router.put("/{prenda_id}", response_model=schemas.PrendaOut)
def update_prenda(prenda_id: int, prenda_update: schemas.PrendaCreate, db: Session = Depends(database.get_db)):
    return crud.crud_prenda.update_prenda(db, prenda_id, prenda_update)

@router.delete("/{prenda_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_prenda(prenda_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_prenda.delete_prenda(db, prenda_id)

@router.get("/usuario/{id_usuario}", response_model=List[schemas.PrendaOut])
def read_prendas_por_usuario(id_usuario: int, db: Session = Depends(database.get_db)):
    prendas = crud.crud_prenda.get_prendas_por_usuario(db, id_usuario)
    if not prendas:
        raise HTTPException(status_code=404, detail="No se encontraron prendas para este usuario")
    return prendas

@router.post("/asociar_ocasion/", status_code=201)
def asociar_ocasion(prenda_id: int, ocasion_id: int, db: Session =  Depends(database.get_db)):
    nueva_asociacion = Prenda_Ocasion(id_prenda=prenda_id, id_ocasion=ocasion_id)
    db.add(nueva_asociacion)
    db.commit()
    return {"mensaje": "Asociación registrada correctamente"}

@router.post("/carga-masiva")
async def carga_masiva_prendas(
    id_usuario: int = Form(...),
    tipo: str = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(database.get_db)
):
    try:
        # 1. Subir la imagen a S3
        url =  upload_image_to_s3(file, id_usuario, folder="outfits")

        # 2. Crear prenda con datos por defecto (puedes mejorarlo con IA después)
        prenda = PrendaCreate(
            nombre=file.filename.split('.')[0],
            tipo=tipo,
            color="#808080",
            temporada="Todo el año",
            estado_uso="Nuevo",
            imagen_url=url,
            id_usuario=id_usuario,
            id_estilo=2  # Asumimos Regular Fit por defecto (ajusta según tu lógica)
        )

        nueva_prenda = crud_prenda.create_prenda(db, prenda)
        return {"mensaje": "Prenda creada", "id_prenda": nueva_prenda.id_prenda}

    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))