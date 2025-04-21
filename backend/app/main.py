from fastapi import FastAPI
from .routers import usuario
from .routers import prenda
from .routers import estilo
from .routers import ocasion
from .routers import outfit
from .routers import detalle_outfit
from .routers import recomendaciones
from .routers import metrica_uso
from .routers import prenda_ocasion
from .routers import historial_uso
from .routers import upload




app = FastAPI()

# Incluir Rutas
app.include_router(usuario.router)
app.include_router(prenda.router)
app.include_router(estilo.router)
app.include_router(ocasion.router)
app.include_router(outfit.router)
app.include_router(detalle_outfit.router)
app.include_router(recomendaciones.router)
app.include_router(metrica_uso.router)
app.include_router(prenda_ocasion.router)
app.include_router(historial_uso.router)
app.include_router(upload.router)


@app.get("/")
def read_root():
    return {"message": "API funcionando correctamente con MySQL"}
