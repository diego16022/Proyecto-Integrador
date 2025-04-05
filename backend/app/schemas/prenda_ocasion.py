from pydantic import BaseModel

class PrendaOcasionBase(BaseModel):
    id_prenda: int
    id_ocasion: int

class PrendaOcasionCreate(PrendaOcasionBase):
    pass

class PrendaOcasionOut(PrendaOcasionBase):
    pass

    class Config:
        from_attributes = True
