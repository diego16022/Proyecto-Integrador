from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/recomendaciones",
    tags=["Recomendaciones"]
)

@router.post("/", response_model=schemas.RecomendacionOut, status_code=status.HTTP_201_CREATED)
def create_recomendacion(recomendacion: schemas.RecomendacionCreate, db: Session = Depends(database.get_db)):
    return crud.crud_recomendaciones.create_recomendacion(db, recomendacion)

@router.get("/", response_model=List[schemas.RecomendacionOut])
def read_recomendaciones(db: Session = Depends(database.get_db)):
    return crud.crud_recomendaciones.get_recomendaciones(db)

@router.get("/{recomendacion_id}", response_model=schemas.RecomendacionOut)
def read_recomendacion(recomendacion_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_recomendaciones.get_recomendacion(db, recomendacion_id)

@router.put("/{recomendacion_id}", response_model=schemas.RecomendacionOut)
def update_recomendacion(recomendacion_id: int, recomendacion_update: schemas.RecomendacionCreate, db: Session = Depends(database.get_db)):
    return crud.crud_recomendaciones.update_recomendacion(db, recomendacion_id, recomendacion_update)

@router.delete("/{recomendacion_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_recomendacion(recomendacion_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_recomendaciones.delete_recomendacion(db, recomendacion_id)
