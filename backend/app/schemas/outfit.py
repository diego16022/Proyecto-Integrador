from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from typing import List

class OutfitBase(BaseModel):
    nombre: str
    id_usuario: int
    id_ocasion: int

class OutfitCreate(OutfitBase):
    pass

class OutfitOut(OutfitBase):
    id_outfit: int
    fecha_creacion: datetime

    class Config:
        from_attributes = True

class OutfitCreate(BaseModel):
    nombre: str
    id_ocasion: int
    ids_prendas: List[int]