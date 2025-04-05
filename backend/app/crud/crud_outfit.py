from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_outfit(db: Session, outfit: schemas.OutfitCreate):
    db_outfit = models.Outfit(**outfit.dict())
    db.add(db_outfit)
    db.commit()
    db.refresh(db_outfit)
    return db_outfit

def get_outfits(db: Session):
    return db.query(models.Outfit).all()

def get_outfit(db: Session, outfit_id: int):
    outfit = db.query(models.Outfit).filter(models.Outfit.id_outfit == outfit_id).first()
    if not outfit:
        raise HTTPException(status_code=404, detail="Outfit no encontrado")
    return outfit

def update_outfit(db: Session, outfit_id: int, outfit_update: schemas.OutfitCreate):
    outfit = get_outfit(db, outfit_id)
    for key, value in outfit_update.dict().items():
        setattr(outfit, key, value)
    db.commit()
    db.refresh(outfit)
    return outfit

def delete_outfit(db: Session, outfit_id: int):
    outfit = get_outfit(db, outfit_id)
    db.delete(outfit)
    db.commit()
