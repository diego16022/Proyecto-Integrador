import boto3
import os

def descargar_modelo():
    modelo_local = "app/modelos/skin_type_model.pt"

    if os.path.exists(modelo_local):
        print(" Modelo ya existe localmente. No se descargará.")
        return

    print("AWS_BUCKET_NAME:", os.getenv("AWS_BUCKET_NAME"))
    print("⬇ Descargando modelo desde S3...")

    s3 = boto3.client("s3",
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
        region_name=os.getenv("AWS_REGION")
    )

    s3.download_file(
        os.getenv("AWS_BUCKET_NAME"),
        "modelos/skin_type_model.pt",
        modelo_local
    )

    print(" Modelo descargado exitosamente.")
