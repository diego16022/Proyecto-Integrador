from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/detalles-outfit",
    tags=["Detalles Outfit"]
)

@router.post("/", response_model=schemas.DetalleOutfitOut, status_code=status.HTTP_201_CREATED)
def create_detalle_outfit(detalle: schemas.DetalleOutfitCreate, db: Session = Depends(database.get_db)):
    return crud.crud_detalle_outfit.create_detalle_outfit(db, detalle)

@router.get("/", response_model=List[schemas.DetalleOutfitOut])
def read_detalles_outfit(db: Session = Depends(database.get_db)):
    return crud.crud_detalle_outfit.get_detalles_outfit(db)

@router.get("/{detalle_id}", response_model=schemas.DetalleOutfitOut)
def read_detalle_outfit(detalle_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_detalle_outfit.get_detalle_outfit(db, detalle_id)

@router.put("/{detalle_id}", response_model=schemas.DetalleOutfitOut)
def update_detalle_outfit(detalle_id: int, detalle_update: schemas.DetalleOutfitCreate, db: Session = Depends(database.get_db)):
    return crud.crud_detalle_outfit.update_detalle_outfit(db, detalle_id, detalle_update)

@router.delete("/{detalle_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_detalle_outfit(detalle_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_detalle_outfit.delete_detalle_outfit(db, detalle_id)
