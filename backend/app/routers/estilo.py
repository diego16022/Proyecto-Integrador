from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/estilos",
    tags=["Estilos"]
)

@router.post("/", response_model=schemas.EstiloOut, status_code=status.HTTP_201_CREATED)
def create_estilo(estilo: schemas.EstiloCreate, db: Session = Depends(database.get_db)):
    return crud.crud_estilo.create_estilo(db, estilo)

@router.get("/", response_model=List[schemas.EstiloOut])
def read_estilos(db: Session = Depends(database.get_db)):
    return crud.crud_estilo.get_estilos(db)

@router.get("/{estilo_id}", response_model=schemas.EstiloOut)
def read_estilo(estilo_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_estilo.get_estilo(db, estilo_id)

@router.put("/{estilo_id}", response_model=schemas.EstiloOut)
def update_estilo(estilo_id: int, estilo_update: schemas.EstiloCreate, db: Session = Depends(database.get_db)):
    return crud.crud_estilo.update_estilo(db, estilo_id, estilo_update)

@router.delete("/{estilo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_estilo(estilo_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_estilo.delete_estilo(db, estilo_id)
