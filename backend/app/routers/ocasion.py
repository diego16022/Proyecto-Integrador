from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/ocasiones",
    tags=["Ocasiones"]
)

@router.post("/", response_model=schemas.OcasionOut, status_code=status.HTTP_201_CREATED)
def create_ocasion(ocasion: schemas.OcasionCreate, db: Session = Depends(database.get_db)):
    return crud.crud_ocasion.create_ocasion(db, ocasion)

@router.get("/", response_model=List[schemas.OcasionOut])
def read_ocasiones(db: Session = Depends(database.get_db)):
    return crud.crud_ocasion.get_ocasiones(db)

@router.get("/{ocasion_id}", response_model=schemas.OcasionOut)
def read_ocasion(ocasion_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_ocasion.get_ocasion(db, ocasion_id)

@router.put("/{ocasion_id}", response_model=schemas.OcasionOut)
def update_ocasion(ocasion_id: int, ocasion_update: schemas.OcasionCreate, db: Session = Depends(database.get_db)):
    return crud.crud_ocasion.update_ocasion(db, ocasion_id, ocasion_update)

@router.delete("/{ocasion_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ocasion(ocasion_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_ocasion.delete_ocasion(db, ocasion_id)
