from fastapi import FastAPI
from .database import engine
from . import models

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "API funcionando correctamente con MySQL"}
