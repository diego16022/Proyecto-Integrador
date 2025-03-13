from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_ocasion(db: Session, ocasion: schemas.OcasionCreate):
    db_ocasion = models.Ocasion_Prenda(**ocasion.dict())
    db.add(db_ocasion)
    db.commit()
    db.refresh(db_ocasion)
    return db_ocasion

def get_ocasiones(db: Session):
    return db.query(models.Ocasion_Prenda).all()

def get_ocasion(db: Session, ocasion_id: int):
    ocasion = db.query(models.Ocasion_Prenda).filter(models.Ocasion_Prenda.id_ocasion == ocasion_id).first()
    if not ocasion:
        raise HTTPException(status_code=404, detail="Ocasion no encontrada")
    return ocasion

def update_ocasion(db: Session, ocasion_id: int, ocasion_update: schemas.OcasionCreate):
    ocasion = get_ocasion(db, ocasion_id)
    for key, value in ocasion_update.dict().items():
        setattr(ocasion, key, value)
    db.commit()
    db.refresh(ocasion)
    return ocasion

def delete_ocasion(db: Session, ocasion_id: int):
    ocasion = get_ocasion(db, ocasion_id)
    db.delete(ocasion)
    db.commit()
