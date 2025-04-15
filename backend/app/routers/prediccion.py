from fastapi import APIRouter, File, UploadFile
from PIL import Image
from torchvision import transforms
import torch
from app.modelos.modelo_skin import SkinTypeClassifier
from app.modelos.descarga import descargar_modelo

descargar_modelo()
# Cargar modelo
modelo = SkinTypeClassifier()
modelo.load_state_dict(torch.load("app/modelos/skin_type_model.pt", map_location=torch.device("cpu")))
modelo.eval()

# Etiquetas
label_mapping = {
    0: 'Tipo_I',
    1: 'Tipo_II',
    2: 'Tipo_III',
    3: 'Tipo_IV',
    4: 'Tipo_V',
    5: 'Tipo_VI'
}

val_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

router = APIRouter()

@router.post("/predecir")
async def predecir_tono_de_piel(file: UploadFile = File(...)):
    image = Image.open(file.file).convert("RGB")
    tensor = val_transform(image).unsqueeze(0)

    with torch.no_grad():
        output = modelo(tensor)
        pred = torch.argmax(output, dim=1).item()
        tipo_piel = label_mapping[pred]

    return {"tipo_piel": tipo_piel}
