from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from .. import schemas, crud, database
from .. import models, schemas
from fastapi import HTTPException
from ..database import get_db
import random
from collections import Counter

def obtener_ocasion_comun(db: Session, prendas: List[models.Prenda]) -> int:
    todas_ocasiones = []

    for prenda in prendas:
        asociaciones = db.query(models.Prenda_Ocasion).filter(
            models.Prenda_Ocasion.id_prenda == prenda.id_prenda
        ).all()
        for asociacion in asociaciones:
            todas_ocasiones.append(asociacion.id_ocasion)

    if not todas_ocasiones:
        return 1  # Default ocasión (e.g., "Casual")

    mas_comun = Counter(todas_ocasiones).most_common(1)[0][0]
    return mas_comun

router = APIRouter(
    prefix="/outfits",
    tags=["Outfits"]
)

@router.post("/", response_model=schemas.OutfitOut, status_code=status.HTTP_201_CREATED)
def create_outfit(outfit: schemas.OutfitCreate, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.create_outfit(db, outfit)

@router.get("/", response_model=List[schemas.OutfitOut])
def read_outfits(db: Session = Depends(database.get_db)):
    return crud.crud_outfit.get_outfits(db)

@router.get("/{outfit_id}", response_model=schemas.OutfitOut)
def read_outfit(outfit_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.get_outfit(db, outfit_id)

@router.put("/{outfit_id}", response_model=schemas.OutfitOut)
def update_outfit(outfit_id: int, outfit_update: schemas.OutfitCreate, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.update_outfit(db, outfit_id, outfit_update)

@router.delete("/{outfit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_outfit(outfit_id: int, db: Session = Depends(database.get_db)):
    return crud.crud_outfit.delete_outfit(db, outfit_id)

@router.post("/{id_usuario}/guardar-outfit")
def guardar_outfit(
    id_usuario: int,
    outfit_data: schemas.OutfitCreate,
    db: Session = Depends(database.get_db)
):
    nuevo_outfit = models.Outfit(
        nombre=outfit_data.nombre,
        id_usuario=id_usuario,
        id_ocasion=outfit_data.id_ocasion
    )
    db.add(nuevo_outfit)
    db.commit()
    db.refresh(nuevo_outfit)

    for id_prenda in outfit_data.ids_prendas:
        detalle = models.Detalle_Outfit(id_outfit=nuevo_outfit.id_outfit, id_prenda=id_prenda)
        db.add(detalle)

    recomendacion = models.Recomendaciones(id_usuario=id_usuario, id_outfit=nuevo_outfit.id_outfit)
    db.add(recomendacion)

    db.commit()
    return {"mensaje": "Outfit guardado exitosamente"}

@router.get("/generar/{usuario_id}")
def generar_outfit(usuario_id: int, db: Session = Depends(get_db)):
    usuario = db.query(models.Usuario).filter(models.Usuario.id_usuario == usuario_id).first()
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")

    tipo_piel = usuario.tono_piel
    if not tipo_piel:
        raise HTTPException(status_code=400, detail="El usuario no tiene análisis cromático")

    colores_favorables = {
        'Tipo I': ["#000080", "#FF00FF", "#FFFFFF", "#000000"],
        'Tipo II': ["#FFC0CB", "#E6E6FA", "#DCDCDC", "#9DC183"],
        'Tipo III': ["#FF7F50", "#98FF98", "#87CEEB", "#40E0D0"],
        'Tipo IV': ["#E2725B", "#808000", "#A0522D", "#FFDB58"],
        'Tipo V': ["#B22222", "#228B22", "#FFBF00", "#7B3F00"],
        'Tipo VI': ["#0047AB", "#50C878", "#8A2BE2", "#C0C0C0"]
    }

    colores = colores_favorables.get(tipo_piel, [])
    camisas = db.query(models.Prenda).filter(
        models.Prenda.tipo == "Camisa",
        models.Prenda.color.in_(colores),
        models.Prenda.id_usuario == usuario_id
    ).all()
    camisa = random.choice(camisas) if camisas else None

    pantalones = db.query(models.Prenda).filter(
        models.Prenda.tipo == "Pantalon",
        models.Prenda.id_usuario == usuario_id
    ).all()
    pantalon = random.choice(pantalones) if pantalones else None

    zapatos_list = db.query(models.Prenda).filter(
        models.Prenda.tipo == "Zapatos",
        models.Prenda.id_usuario == usuario_id
    ).all()
    zapatos = random.choice(zapatos_list) if zapatos_list else None

    if not camisa or not pantalon or not zapatos:
        raise HTTPException(status_code=404, detail="No hay suficientes prendas")

    return {
        "imagen_outfit": camisa.imagen_url,  # Imagen destacada
        "prendas": [camisa.id_prenda, pantalon.id_prenda, zapatos.id_prenda],
        "imagenes_prendas": [
            camisa.imagen_url,
            pantalon.imagen_url,
            zapatos.imagen_url
        ],
        "tono_piel": tipo_piel
    }

@router.post("/aceptar/{usuario_id}", status_code=201)
def aceptar_outfit(usuario_id: int, db: Session = Depends(get_db)):
    # Recuperar las prendas más recientes sugeridas
    camisa = db.query(models.Prenda).filter(
        models.Prenda.tipo == "Camisa", models.Prenda.id_usuario == usuario_id
    ).first()
    pantalon = db.query(models.Prenda).filter(
        models.Prenda.tipo == "Pantalon", models.Prenda.id_usuario == usuario_id
    ).first()
    zapatos = db.query(models.Prenda).filter(
        models.Prenda.tipo == "Zapatos", models.Prenda.id_usuario == usuario_id
    ).first()

    if not camisa or not pantalon or not zapatos:
        raise HTTPException(status_code=404, detail="Faltan prendas para guardar outfit")

    # ✅ Obtener la ocasión más común entre las prendas
    id_ocasion = obtener_ocasion_comun(db, [camisa, pantalon, zapatos])

    nuevo_outfit = models.Outfit(
        id_usuario=usuario_id,
        nombre="Outfit generado",
        id_ocasion=id_ocasion
    )
    db.add(nuevo_outfit)
    db.commit()
    db.refresh(nuevo_outfit)

    for prenda in [camisa, pantalon, zapatos]:
        detalle = models.Detalle_Outfit(id_outfit=nuevo_outfit.id_outfit, id_prenda=prenda.id_prenda)
        db.add(detalle)

    recomendacion = models.Recomendaciones(
        id_usuario=usuario_id,
        id_outfit=nuevo_outfit.id_outfit,
        feedback_usuario="aceptado"
    )
    db.add(recomendacion)
    db.commit()

    return {"message": "Outfit guardado correctamente"}
