# utils/s3_upload.py
import boto3
import uuid
import os
import base64
import io
from dotenv import load_dotenv
load_dotenv()

print("AWS_BUCKET_NAME:", os.getenv("AWS_BUCKET_NAME"))

s3 = boto3.client(
    "s3",
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
    region_name=os.getenv("AWS_REGION"),
)

BUCKET_NAME = os.getenv("AWS_BUCKET_NAME")

def upload_image_to_s3(file, id_usuario, folder="outfits"):
    ext = file.filename.split('.')[-1]
    filename = f"{folder}/user_{id_usuario}/{uuid.uuid4()}.{ext}"

    s3.upload_fileobj(file.file, BUCKET_NAME, filename, ExtraArgs={"ContentType": file.content_type})

    image_url = f"https://{BUCKET_NAME}.s3.{os.getenv('AWS_REGION')}.amazonaws.com/{filename}"
    return image_url

def upload_base64_image_to_s3(base64_str, id_usuario, folder="users/recortes"):
    ext = "jpg"
    filename = f"{folder}/user_{id_usuario}/{uuid.uuid4()}.{ext}"

    image_data = base64.b64decode(base64_str)
    file_obj = io.BytesIO(image_data)

    s3.upload_fileobj(file_obj, BUCKET_NAME, filename, ExtraArgs={"ContentType": "image/jpeg"})

    image_url = f"https://{BUCKET_NAME}.s3.{os.getenv('AWS_REGION')}.amazonaws.com/{filename}"
    return image_url
