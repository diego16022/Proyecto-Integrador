from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database
from ..schemas import UsuarioCreate, UsuarioOut


router = APIRouter(
    prefix="/usuarios",
    tags=["Usuarios"]
)

@router.post("/", response_model=UsuarioOut, status_code=status.HTTP_201_CREATED)
def create_usuario(usuario: UsuarioCreate, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.create_usuario(db, usuario)

@router.get("/", response_model=List[UsuarioOut])
def read_usuarios(db: Session = Depends(database.get_db)):
    return crud.crud_usuario.get_usuarios(db)

@router.get("/{usuario_id}", response_model=UsuarioOut)
def read_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.get_usuario(db, usuario_id)

@router.put("/{usuario_id}", response_model=UsuarioOut)
def update_usuario(usuario_id: int, usuario_update: UsuarioCreate, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.update_usuario(db, usuario_id, usuario_update)

@router.delete("/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_usuario(usuario_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_usuario.delete_usuario(db, usuario_id)
