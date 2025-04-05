from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database

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
