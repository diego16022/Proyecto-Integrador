# 🤖 Modelos de Inteligencia Artificial

Esta carpeta contiene todo lo relacionado con la integración del modelo de IA encargado de realizar el análisis cromático del usuario. El sistema utiliza un modelo de clasificación basado en **ResNet34**, entrenado en PyTorch, para predecir el **tono de piel** del usuario a partir de una imagen facial.

---
## 🗂️ Archivos

| Archivo               | Funcionalidad                                                  |
|------------------------|---------------------------------------------------------------|
| `modelo_skin.py`       | Funciones para cargar el modelo y hacer predicciones          |
| `descarga.py`          | Script para descargar el modelo desde una URL (si aplica)     |
| `skin_type_model.pt`   | Modelo preentrenado guardado en formato PyTorch (`.pt`)       |

---
## 🧠 Modelo: `skin_type_model.pt`

- Arquitectura: `ResNet34`
- Framework: `PyTorch`
- Salida esperada: Clases `Tipo I` a `Tipo VI` (6 tipos de tonos de piel)
- Entrenado con: imágenes etiquetadas de tonos de piel
- Se usa para: recomendaciones personalizadas de colores en atuendos

---
## ⚙️ Flujo de uso

1. El usuario sube una imagen (desde Flutter)
2. Se guarda temporalmente o se procesa directamente
3. El modelo se carga y predice la clase de tono de piel
4. Se devuelve una respuesta estructurada y se guarda en la base de datos

---
## 🧩 Ejemplo de uso

```python
from app.modelos.modelo_skin import predecir_tono_piel

# Ruta local de imagen subida
image_path = "user_photo.jpg"

# Obtener predicción
tono = predecir_tono_piel(image_path)
print("Tono detectado:", tono)  # Ejemplo: "Tipo IV"
```
---
## 📁 Estructura del modelo
```python
from app.modelos.modelo_skin import predecir_tono_piel

# Ruta local de imagen subida
image_path = "user_photo.jpg"

# Obtener predicción
tono = predecir_tono_piel(image_path)
print("Tono detectado:", tono)  # Ejemplo: "Tipo IV"
```
---
## 🧪 Buenas prácticas

- El modelo debe estar en modo eval() al usarse
- Las imágenes deben preprocesarse igual que durante el entrenamiento (tamaño, normalización, etc.)
- Las predicciones deben mapearse a una etiqueta (Tipo I - Tipo VI) clara para el usuario
---
## ✅ Recomendaciones

- No subir modelos muy pesados al repositorio (puede usarse descarga desde S3 o HuggingFace)
- Mantener las transformaciones de preprocesamiento en funciones reutilizables
- Hacer pruebas unitarias con imágenes de ejemplo para validar consistencia
---
Autor
Diego Andrés Reinoso Calderón

