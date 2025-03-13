from pydantic import BaseModel

class MetricaUsoBase(BaseModel):
    id_prenda: int
    veces_usada: int
    dias_sin_uso: int

class MetricaUsoCreate(MetricaUsoBase):
    pass

class MetricaUsoOut(MetricaUsoBase):
    id_metrica: int

    class Config:
        from_attributes = True
