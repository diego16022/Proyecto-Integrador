from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum

class TemporadaEnum(str, Enum):
    verano = "Verano"
    invierno = "Invierno"
    otono = "Otoño"
    primavera = "Primavera"
    todo_el_ano = "Todo el año"

class EstadoUsoEnum(str, Enum):
    nuevo = "Nuevo"
    poco_usado = "Poco usado"
    usado = "Usado"
    viejo = "Viejo"

class PrendaBase(BaseModel):
    nombre: str
    tipo: str
    color: str
    temporada: TemporadaEnum
    estado_uso: EstadoUsoEnum
    imagen_url: Optional[str] = None

class PrendaCreate(PrendaBase):
    id_usuario: int
    id_estilo: int
    id_ocasion: int

class PrendaOut(PrendaBase):
    id_prenda: int
    id_estilo: int
    id_usuario: int
    fecha_registro: Optional[datetime]


    class Config:
        from_attributes = True
