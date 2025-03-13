from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/outfits",
    tags=["Outfits"]
)

@router.post("/", response_model=schemas.OutfitOut, status_code=status.HTTP_201_CREATED)
def create_outfit(outfit: schemas.OutfitCreate, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.create_outfit(db, outfit)

@router.get("/", response_model=List[schemas.OutfitOut])
def read_outfits(db: Session = Depends(database.get_db)):
    return crud.crud_outfit.get_outfits(db)

@router.get("/{outfit_id}", response_model=schemas.OutfitOut)
def read_outfit(outfit_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.get_outfit(db, outfit_id)

@router.put("/{outfit_id}", response_model=schemas.OutfitOut)
def update_outfit(outfit_id: int, outfit_update: schemas.OutfitCreate, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.update_outfit(db, outfit_id, outfit_update)

@router.delete("/{outfit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_outfit(outfit_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.delete_outfit(db, outfit_id)
