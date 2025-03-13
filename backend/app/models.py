from sqlalchemy import Column, Integer, String, ForeignKey, Enum, DateTime, Table, Date
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from .database import Base
import enum

# Enumeraciones 

class TipoPrendaEnum (str,enum.Enum):
    Camisa="Camisa"
    Pantalon="Pantalon"
    Zapatos="Zapatos"
    Accesorios="Accesorios"

class TemporadaEnum (str,enum.Enum):
    Verano = "Verano"
    Invierno = "Invierno"
    Otono = "Otoño"
    Primavera = "Primavera"
    Todo_el_ano = "Todo el año"

class EstadoUsoEnum (str, enum.Enum):
    Nuevo = "Nuevo"
    Poco_usado = "Poco usado"
    Usado = "Usado"
    Viejo = "Viejo"

class FeedbackEnum (str, enum.Enum):
    Me_gusta = "Me gusta"
    No_me_gusta = "No me gusta"
    Neutral = "Neutral"

# Modelo de Usuario
class Usuario(Base):
    __tablename__ = "Usuario"

    id_usuario = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    contrasena = Column(String(100), nullable=False)
    tono_piel = Column(String(50))
    fecha_registro = Column(DateTime, server_default=func.now())
    # Relación con la tabla Prenda
    prendas = relationship("Prenda", back_populates="usuario")
    outfits = relationship("Outfit", back_populates="usuario")
    recomendaciones = relationship("Recomendaciones", back_populates="usuario")
    historial = relationship("Historial_de_Uso", back_populates="usuario")

# Modelo de Prenda
class Prenda(Base):
    __tablename__ = "Prenda"

    id_prenda = Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("Usuario.id_usuario"))
    nombre = Column(String(100), nullable=False)
    tipo = Column(Enum(TipoPrendaEnum), nullable=False)
    color = Column(String(50), nullable=False)
    temporada = Column(Enum(TemporadaEnum))
    estado_uso = Column(Enum(EstadoUsoEnum))
    id_estilo = Column(Integer, ForeignKey("Estilo_Prenda.id_estilo"))
    imagen_url = Column(String(255))
    fecha_registro = Column(DateTime, server_default=func.now())

    # Relación inversa con Usuario
    usuario = relationship("Usuario", back_populates="prendas")
    estilo = relationship("Estilo_Prenda", back_populates="prendas")
    metrica = relationship("Metrica_Uso", back_populates="prenda")
    ocasiones = relationship("Prenda_Ocasion", back_populates="prenda")

#Estilo_Prenda 

class Estilo_Prenda(Base):
    __tablename__ = "Estilo_Prenda"

    id_estilo = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(50), nullable=False)

    prendas = relationship("Prenda", back_populates="estilo")

#Ocasion_Prenda

class Ocasion_Prenda(Base):
    __tablename__ = "Ocasion_Prenda"

    id_ocasion = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(50), nullable=False)

#Outfit
class Outfit(Base):
    __tablename__ = "Outfit"

    id_outfit = Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("Usuario.id_usuario"))
    nombre = Column(String(100), nullable=False)
    id_ocasion = Column(Integer, ForeignKey("Ocasion_Prenda.id_ocasion"))
    fecha_creacion = Column(DateTime, server_default=func.now())

    usuario = relationship("Usuario", back_populates="outfits")
    detalles = relationship("Detalle_Outfit", back_populates="outfit")

#Detalle_Outfit
class Detalle_Outfit(Base):
    __tablename__ = "Detalle_Outfit"

    id_detalle = Column(Integer, primary_key=True, index=True)
    id_outfit = Column(Integer, ForeignKey("Outfit.id_outfit"))
    id_prenda = Column(Integer, ForeignKey("Prenda.id_prenda"))

    outfit = relationship("Outfit", back_populates="detalles")
    prenda = relationship("Prenda")


#Recomendaciones
class Recomendaciones(Base):
    __tablename__ = "Recomendaciones"

    id_recomendacion = Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("Usuario.id_usuario"))
    id_outfit = Column(Integer, ForeignKey("Outfit.id_outfit"))
    fecha_recomendacion = Column(DateTime, server_default=func.now())
    feedback_usuario = Column(Enum(FeedbackEnum))

    usuario = relationship("Usuario", back_populates="recomendaciones")

#Historial de Uso
class Historial_de_Uso(Base):
    __tablename__ = "Historial_de_Uso"

    id_historial = Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("Usuario.id_usuario"))
    id_outfit = Column(Integer, ForeignKey("Outfit.id_outfit"))
    fecha_uso = Column(Date)
    clima = Column(String(50))

    usuario = relationship("Usuario", back_populates="historial")

#Metrica Uso
class Metrica_Uso(Base):
    __tablename__ = "Metrica_Uso"

    id_metrica = Column(Integer, primary_key=True, index=True)
    id_prenda = Column(Integer, ForeignKey("Prenda.id_prenda"))
    veces_usada = Column(Integer, nullable=False)
    dias_sin_uso = Column(Integer)

    prenda = relationship("Prenda", back_populates="metrica")
#Prenda Ocasion 
class Prenda_Ocasion(Base):
    __tablename__ = "Prenda_Ocasion"

    id_prenda = Column(Integer, ForeignKey("Prenda.id_prenda"), primary_key=True)
    id_ocasion = Column(Integer, ForeignKey("Ocasion_Prenda.id_ocasion"), primary_key=True)

    prenda = relationship("Prenda", back_populates="ocasiones")