from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_detalle_outfit(db: Session, detalle: schemas.DetalleOutfitCreate):
    db_detalle = models.Detalle_Outfit(**detalle.dict())
    db.add(db_detalle)
    db.commit()
    db.refresh(db_detalle)
    return db_detalle

def get_detalles_outfit(db: Session):
    return db.query(models.Detalle_Outfit).all()

def get_detalle_outfit(db: Session, detalle_id: int):
    detalle = db.query(models.Detalle_Outfit).filter(models.Detalle_Outfit.id_detalle == detalle_id).first()
    if not detalle:
        raise HTTPException(status_code=404, detail="Detalle del Outfit no encontrado")
    return detalle

def update_detalle_outfit(db: Session, detalle_id: int, detalle_update: schemas.DetalleOutfitCreate):
    detalle = get_detalle_outfit(db, detalle_id)
    for key, value in detalle_update.dict().items():
        setattr(detalle, key, value)
    db.commit()
    db.refresh(detalle)
    return detalle

def delete_detalle_outfit(db: Session, detalle_id: int):
    detalle = get_detalle_outfit(db, detalle_id)
    db.delete(detalle)
    db.commit()
