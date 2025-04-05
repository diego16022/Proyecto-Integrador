# routers/upload.py
from fastapi import APIRouter, UploadFile, File, Form
from ..utils.s3_upload import upload_image_to_s3

router = APIRouter(
    prefix="/upload",
    tags=["Uploads"]
)

@router.post("/image")
async def upload_image(
    id_usuario: int = Form(...),
    file: UploadFile = File(...)
):
    image_url = upload_image_to_s3(file, id_usuario)
    return {"url": image_url}
