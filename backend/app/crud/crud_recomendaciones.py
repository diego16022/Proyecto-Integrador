from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_recomendacion(db: Session, recomendacion: schemas.RecomendacionCreate):
    db_recomendacion = models.Recomendaciones(**recomendacion.dict())
    db.add(db_recomendacion)
    db.commit()
    db.refresh(db_recomendacion)
    return db_recomendacion

def get_recomendaciones(db: Session):
    return db.query(models.Recomendaciones).all()

def get_recomendacion(db: Session, recomendacion_id: int):
    recomendacion = db.query(models.Recomendaciones).filter(models.Recomendaciones.id_recomendacion == recomendacion_id).first()
    if not recomendacion:
        raise HTTPException(status_code=404, detail="Recomendación no encontrada")
    return recomendacion

def update_recomendacion(db: Session, recomendacion_id: int, recomendacion_update: schemas.RecomendacionCreate):
    recomendacion = get_recomendacion(db, recomendacion_id)
    for key, value in recomendacion_update.dict().items():
        setattr(recomendacion, key, value)
    db.commit()
    db.refresh(recomendacion)
    return recomendacion

def delete_recomendacion(db: Session, recomendacion_id: int):
    recomendacion = get_recomendacion(db, recomendacion_id)
    db.delete(recomendacion)
    db.commit()
