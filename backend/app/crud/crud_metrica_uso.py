from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_metrica(db: Session, metrica: schemas.MetricaUsoCreate):
    db_metrica = models.Metrica_Uso(**metrica.dict())
    db.add(db_metrica)
    db.commit()
    db.refresh(db_metrica)
    return db_metrica

def get_metricas(db: Session):
    return db.query(models.Metrica_Uso).all()

def get_metrica(db: Session, metrica_id: int):
    metrica = db.query(models.Metrica_Uso).filter(models.Metrica_Uso.id_metrica == metrica_id).first()
    if not metrica:
        raise HTTPException(status_code=404, detail="Metrica no encontrada")
    return metrica

def update_metrica(db: Session, metrica_id: int, metrica_update: schemas.MetricaUsoCreate):
    metrica = get_metrica(db, metrica_id)
    for key, value in metrica_update.dict().items():
        setattr(metrica, key, value)
    db.commit()
    db.refresh(metrica)
    return metrica

def delete_metrica(db: Session, metrica_id: int):
    metrica = get_metrica(db, metrica_id)
    db.delete(metrica)
    db.commit()
