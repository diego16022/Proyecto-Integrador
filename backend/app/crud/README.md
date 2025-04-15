# 📦 CRUD - Lógica de negocio

Esta carpeta contiene la lógica de operaciones sobre la base de datos para cada entidad del sistema. Cada archivo maneja funciones específicas para interactuar con la base de datos usando SQLAlchemy.

---
## Archivos
  - `crud_usuario.py` → Operaciones con usuarios (crear, obtener por ID, login)
  - `crud_prenda.py` → CRUD para prendas de ropa
  - `crud_outfit.py` → Guardado y consulta de outfits generados
  - `crud_ocasion.py` → Relación entre ocasiones y prendas/outfits

## Ejemplo de uso (crud_usuario.py)
```python
from app.crud.crud_usuario import crear_usuario
from app.schemas.usuario import UsuarioCreate

nuevo_usuario = UsuarioCreate(nombre="Diego", correo="diego@mail.com", contrasena="123")
usuario = crear_usuario(db=session, usuario=nuevo_usuario)
