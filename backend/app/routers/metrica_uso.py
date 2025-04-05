from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/metricas-uso",
    tags=["Metrica de Uso"]
)

@router.post("/", response_model=schemas.MetricaUsoOut, status_code=status.HTTP_201_CREATED)
def create_metrica(metrica: schemas.MetricaUsoCreate, db: Session = Depends(database.get_db)):
    return crud.crud_metrica_uso.create_metrica(db, metrica)

@router.get("/", response_model=List[schemas.MetricaUsoOut])
def read_metricas(db: Session = Depends(database.get_db)):
    return crud.crud_metrica_uso.get_metricas(db)

@router.get("/{metrica_id}", response_model=schemas.MetricaUsoOut)
def read_metrica(metrica_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_metrica_uso.get_metrica(db, metrica_id)

@router.put("/{metrica_id}", response_model=schemas.MetricaUsoOut)
def update_metrica(metrica_id: int, metrica_update: schemas.MetricaUsoCreate, db: Session = Depends(database.get_db)):
    return crud.crud_metrica_uso.update_metrica(db, metrica_id, metrica_update)

@router.delete("/{metrica_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_metrica(metrica_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_metrica_uso.delete_metrica(db, metrica_id)
