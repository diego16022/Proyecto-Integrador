from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from ..models import FeedbackEnum

class RecomendacionBase(BaseModel):
    id_usuario: int
    id_outfit: int
    feedback_usuario: FeedbackEnum

class RecomendacionCreate(RecomendacionBase):
    pass

class RecomendacionOut(RecomendacionBase):
    id_recomendacion: int
    fecha_recomendacion: Optional[datetime]

    class Config:
        from_attributes = True
