from pydantic import BaseModel

class EstiloBase(BaseModel):
    nombre: str

class EstiloCreate(EstiloBase):
    pass

class EstiloOut(EstiloBase):
    id_estilo: int

    class Config:
        from_attributes = True
