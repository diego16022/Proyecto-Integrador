from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_estilo(db: Session, estilo: schemas.EstiloCreate):
    db_estilo = models.Estilo_Prenda(**estilo.dict())
    db.add(db_estilo)
    db.commit()
    db.refresh(db_estilo)
    return db_estilo

def get_estilos(db: Session):
    return db.query(models.Estilo_Prenda).all()

def get_estilo(db: Session, estilo_id: int):
    estilo = db.query(models.Estilo_Prenda).filter(models.Estilo_Prenda.id_estilo == estilo_id).first()
    if not estilo:
        raise HTTPException(status_code=404, detail="Estilo no encontrado")
    return estilo

def update_estilo(db: Session, estilo_id: int, estilo_update: schemas.EstiloCreate):
    estilo = get_estilo(db, estilo_id)
    for key, value in estilo_update.dict().items():
        setattr(estilo, key, value)
    db.commit()
    db.refresh(estilo)
    return estilo

def delete_estilo(db: Session, estilo_id: int):
    estilo = get_estilo(db, estilo_id)
    db.delete(estilo)
    db.commit()
