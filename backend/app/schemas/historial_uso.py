from pydantic import BaseModel
from datetime import date

class HistorialUsoBase(BaseModel):
    id_usuario: int
    id_outfit: int
    fecha_uso: date
    clima: str

class HistorialUsoCreate(HistorialUsoBase):
    pass

class HistorialUsoOut(HistorialUsoBase):
    id_historial: int

    class Config:
        from_attributes = True
