import cloudinary
import cloudinary.uploader
from config import Config

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