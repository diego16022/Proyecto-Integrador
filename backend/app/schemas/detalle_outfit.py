from pydantic import BaseModel

class DetalleOutfitBase(BaseModel):
    id_outfit: int
    id_prenda: int

class DetalleOutfitCreate(DetalleOutfitBase):
    pass

class DetalleOutfitOut(DetalleOutfitBase):
    id_detalle: int

    class Config:
        from_attributes = True
