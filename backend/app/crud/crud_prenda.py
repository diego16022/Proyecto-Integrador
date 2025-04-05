from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException
from .. import models, schemas

def create_prenda(db: Session, prenda: schemas.PrendaCreate):
    db_prenda = models.Prenda(**prenda.dict())
    db.add(db_prenda)
    db.commit()
    db.refresh(db_prenda)
    return db_prenda

def get_prendas(db: Session):
    return db.query(models.Prenda).all()

def get_prenda(db: Session, prenda_id: int):
    prenda = db.query(models.Prenda).filter(models.Prenda.id_prenda == prenda_id).first()
    if not prenda:
        raise HTTPException(status_code=404, detail="Prenda no encontrada")
    return prenda

def update_prenda(db: Session, prenda_id: int, prenda_update: schemas.PrendaCreate):
    prenda = get_prenda(db, prenda_id)
    for key, value in prenda_update.dict().items():
        setattr(prenda, key, value)
    db.commit()
    db.refresh(prenda)
    return prenda

def delete_prenda(db: Session, prenda_id: int):
    prenda = get_prenda(db, prenda_id)
    db.delete(prenda)
    db.commit()
    
def get_prendas_por_usuario(db: Session, id_usuario: int):
    return db.query(models.Prenda).filter(models.Prenda.id_usuario == id_usuario).all()
