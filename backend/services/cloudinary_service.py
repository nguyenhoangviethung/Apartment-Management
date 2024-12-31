import cloudinary
import cloudinary.uploader
from config import Config
from werkzeug.utils import secure_filename
import os

cloudinary.config(
    cloud_name=Config.CLOUD_NAME_CLOUDINARY,
    api_key=Config.API_PUBLIC_CLOUDINARY,
    api_secret=Config.API_SECRET_CLOUDINARY,
    secure=True
)

def upload_image_to_cloudinary(path_to_img, public_id):
    """
    Upload an image to Cloudinary.
    :param path_to_img: URL or local path to the image.
    :param public_id: The public ID to use for the image in Cloudinary.
    :return: The response dictionary from Cloudinary.
    """
    return cloudinary.uploader.upload(path_to_img, public_id=public_id)

def save_and_upload_image(file, public_id, upload_folder="temp_uploads"):
    """
    Save the uploaded file temporarily and upload it to Cloudinary.
    :param file: The file object (e.g., from an HTTP request).
    :param public_id: The public ID to use for the image in Cloudinary.
    :param upload_folder: Temporary folder to store the file.
    :return: The response dictionary from Cloudinary.
    """
    # Ensure the temporary upload folder exists
    if not os.path.exists(upload_folder):
        os.makedirs(upload_folder)

    # Secure the filename and save it temporarily
    filename = secure_filename(file.filename)
    temp_path = os.path.join(upload_folder, filename)
    file.save(temp_path)

    try:
        # Upload to Cloudinary
        response = upload_image_to_cloudinary(temp_path, public_id)
    finally:
        # Clean up the temporary file
        os.remove(temp_path)

    return response