from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

router = APIRouter(
    prefix="/prenda-ocasion",
    tags=["Prenda Ocasion"]
)

@router.post("/", response_model=schemas.PrendaOcasionOut, status_code=status.HTTP_201_CREATED)
def create_prenda_ocasion(prenda_ocasion: schemas.PrendaOcasionCreate, db: Session = Depends(database.get_db)):
    return crud.crud_prenda_ocasion.create_prenda_ocasion(db, prenda_ocasion)

@router.get("/", response_model=List[schemas.PrendaOcasionOut])
def read_prendas_ocasiones(db: Session = Depends(database.get_db)):
    return crud.crud_prenda_ocasion.get_prendas_ocasiones(db)

@router.get("/{id_prenda}/{id_ocasion}", response_model=schemas.PrendaOcasionOut)
def read_prenda_ocasion(id_prenda: int, id_ocasion: int, db: Session = Depends(database.get_db)):
    return crud.crud_prenda_ocasion.get_prenda_ocasion(db, id_prenda, id_ocasion)

@router.delete("/{id_prenda}/{id_ocasion}", status_code=status.HTTP_204_NO_CONTENT)
def delete_prenda_ocasion(id_prenda: int, id_ocasion: int, db: Session = Depends(database.get_db)):
    return crud.crud_prenda_ocasion.delete_prenda_ocasion(db, id_prenda, id_ocasion)
