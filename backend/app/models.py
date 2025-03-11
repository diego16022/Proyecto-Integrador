from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

# Modelo de Usuario
class Usuario(Base):
    __tablename__ = "Usuario"

    id_usuario = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    contraseña = Column(String(100), nullable=False)

    # Relación con la tabla Prenda
    prendas = relationship("Prenda", back_populates="usuario")

# Modelo de Prenda
class Prenda(Base):
    __tablename__ = "Prenda"

    id_prenda = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    color = Column(String(50), nullable=False)
    tipo = Column(String(50), nullable=False)
    id_usuario = Column(Integer, ForeignKey("Usuario.id_usuario"))

    # Relación inversa con Usuario
    usuario = relationship("Usuario", back_populates="prendas")
