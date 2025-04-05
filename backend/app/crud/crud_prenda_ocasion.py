from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_prenda_ocasion(db: Session, prenda_ocasion: schemas.PrendaOcasionCreate):
    db_prenda_ocasion = models.Prenda_Ocasion(**prenda_ocasion.dict())
    db.add(db_prenda_ocasion)
    db.commit()
    db.refresh(db_prenda_ocasion)
    return db_prenda_ocasion

def get_prendas_ocasiones(db: Session):
    return db.query(models.Prenda_Ocasion).all()

def get_prenda_ocasion(db: Session, id_prenda: int, id_ocasion: int):
    prenda_ocasion = db.query(models.Prenda_Ocasion).filter(
        models.Prenda_Ocasion.id_prenda == id_prenda,
        models.Prenda_Ocasion.id_ocasion == id_ocasion
    ).first()
    if not prenda_ocasion:
        raise HTTPException(status_code=404, detail="Prenda-Ocasion no encontrada")
    return prenda_ocasion

def delete_prenda_ocasion(db: Session, id_prenda: int, id_ocasion: int):
    prenda_ocasion = get_prenda_ocasion(db, id_prenda, id_ocasion)
    db.delete(prenda_ocasion)
    db.commit()
