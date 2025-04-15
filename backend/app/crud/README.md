# 🔄 CRUD - Lógica de Base de Datos

Esta carpeta contiene las funciones que implementan operaciones **Create, Read, Update y Delete** sobre las entidades del sistema, usando **SQLAlchemy ORM**. Se utiliza como capa intermedia entre los `routers/` y la base de datos, manteniendo el código organizado y reutilizable.

---
## 🗂️ Archivos principales

| Archivo                | Funcionalidad                                              |
|------------------------|-------------------------------------------------------------|
| `crud_usuario.py`       | Registro, login, obtener usuario por ID/correo             |
| `crud_prenda.py`        | Crear, listar, editar y eliminar prendas                   |
| `crud_outfit.py`        | Guardar outfits generados y consultar historial            |
| `crud_estilo.py`        | Operaciones sobre estilos de prenda                        |
| `crud_ocasion.py`       | Crear y listar ocasiones relacionadas                      |
| `crud_metrica_uso.py`   | Registro de uso y métricas de rotación                     |
| `crud_historial_uso.py` | Historial de uso de atuendos                               |
| `crud_prenda_ocasion.py`| Relación entre prendas y ocasiones                         |
| `crud_detalle_outfit.py`| Asociación de prendas dentro de un outfit                  |

---
## 📦 Ejemplo de uso (Usuario)

Archivo: `crud_usuario.py`

```python
from app.crud import crud_usuario
from app.schemas.usuario import UsuarioCreate

usuario_creado = crud_usuario.crear_usuario(db, UsuarioCreate(
    nombre="Diego",
    correo="diego@email.com",
    contrasena="123456"
))
```
---
## 🧠 Patrón utilizado
Cada archivo implementa funciones como:
```python
def crear_<entidad>(db: Session, data: <Schema>):
    ...
def obtener_<entidad>_por_id(db: Session, id: int):
    ...
def eliminar_<entidad>(db: Session, id: int):
    ...
```
---
## 🔁 Flujo típico
1.schemas/ valida y estructura los datos entrantes
2. routers/ recibe la petición y llama al método CRUD correspondiente
3.crud/ ejecuta la lógica de base de datos usando SQLAlchemy
4. Se retorna una respuesta al cliente

---
## 📤 Ejemplo CRUD de prenda
Archivo: crud_prenda.py
```python
def crear_prenda(db: Session, prenda: PrendaCreate):
    db_prenda = Prenda(**prenda.dict())
    db.add(db_prenda)
    db.commit()
    db.refresh(db_prenda)
    return db_prenda
```
---
## 🧪 Buenas prácticas
- Usa db.commit() seguido de db.refresh() para obtener datos actualizados
- Asegúrate de manejar errores como IntegrityError y NoResultFound
- Separa la lógica de negocio compleja (como filtros avanzados) para mantener funciones CRUD limpias
- Siempre retorna objetos ORM si usas orm_mode = True en schemas
---
## ✅ Recomendaciones
- Agrupa funciones por entidad
- Prefiere nombres explícitos como obtener_outfits_por_usuario() en vez de listar()
- Utiliza transacciones si haces múltiples operaciones encadenadas
---
Autor

Diego Andrés Reinoso Calderón

Proyecto: Outfit Recommender



