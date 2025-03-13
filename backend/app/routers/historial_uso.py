from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/historial-uso",
    tags=["Historial de Uso"]
)

@router.post("/", response_model=schemas.HistorialUsoOut, status_code=status.HTTP_201_CREATED)
def create_historial(historial: schemas.HistorialUsoCreate, db: Session = Depends(database.get_db)):
    return crud.crud_historial_uso.create_historial_uso(db, historial)

@router.get("/", response_model=List[schemas.HistorialUsoOut])
def read_historiales(db: Session = Depends(database.get_db)):
    return crud.crud_historial_uso.get_historiales(db)

@router.get("/{historial_id}", response_model=schemas.HistorialUsoOut)
def read_historial(historial_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_historial_uso.get_historial(db, historial_id)

@router.put("/{historial_id}", response_model=schemas.HistorialUsoOut)
def update_historial(historial_id: int, historial_update: schemas.HistorialUsoCreate, db: Session = Depends(database.get_db)):
    return crud.crud_historial_uso.update_historial(db, historial_id, historial_update)

@router.delete("/{historial_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_historial(historial_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_historial_uso.delete_historial(db, historial_id)
