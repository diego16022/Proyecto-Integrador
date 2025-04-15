from pydantic import BaseModel
from typing import Optional


class UsuarioBase(BaseModel):
    nombre: str
    email: str
    tono_piel: Optional[str] = None

class UsuarioCreate(UsuarioBase):
    contrasena: str

class UsuarioOut(UsuarioBase):
    id_usuario: int

    class Config:
        orm_mode = True

class UsuarioLogin(BaseModel):
    email: str
    contrasena: str

class UsuarioUpdate(BaseModel):
    nombre: str = None
    email: str = None
    contrasena: str= None
    tono_piel: str = None

class AnalisisCromaticoIn(BaseModel):
    foto_url: str
    tono_piel: str