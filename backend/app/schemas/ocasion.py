from pydantic import BaseModel

class OcasionBase(BaseModel):
    nombre: str

class OcasionCreate(OcasionBase):
    pass

class OcasionOut(OcasionBase):
    id_ocasion: int

    class Config:
        from_attributes = True
