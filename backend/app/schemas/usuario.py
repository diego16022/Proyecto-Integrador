from pydantic import BaseModel

class UsuarioBase(BaseModel):
    nombre: str
    email: str
    tono_piel: str = None

class UsuarioCreate(UsuarioBase):
    contraseña: str

class UsuarioOut(UsuarioBase):
    id_usuario: int

    class Config:
        orm_mode = True
