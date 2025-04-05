from sqlalchemy.orm import Session
from fastapi import HTTPException
from .. import models, schemas

def create_historial_uso(db: Session, historial: schemas.HistorialUsoCreate):
    db_historial = models.Historial_de_Uso(**historial.dict())
    db.add(db_historial)
    db.commit()
    db.refresh(db_historial)
    return db_historial

def get_historiales(db: Session):
    return db.query(models.Historial_de_Uso).all()

def get_historial(db: Session, historial_id: int):
    historial = db.query(models.Historial_de_Uso).filter(models.Historial_de_Uso.id_historial == historial_id).first()
    if not historial:
        raise HTTPException(status_code=404, detail="Historial de uso no encontrado")
    return historial

def update_historial(db: Session, historial_id: int, historial_update: schemas.HistorialUsoCreate):
    historial = get_historial(db, historial_id)
    for key, value in historial_update.dict().items():
        setattr(historial, key, value)
    db.commit()
    db.refresh(historial)
    return historial

def delete_historial(db: Session, historial_id: int):
    historial = get_historial(db, historial_id)
    db.delete(historial)
    db.commit()
