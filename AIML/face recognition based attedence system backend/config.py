import os

class Config:
    UPLOAD_FOLDER = os.environ.get('UPLOAD_FOLDER', 'uploads')
    PHOTOS_FOLDER = os.environ.get('PHOTOS_FOLDER', 'photos')
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}
    SECRET_KEY = os.environ.get('SECRET_KEY', 'supersecretkey')
    PORT = int(os.environ.get('PORT', 5000))
    HOST = os.environ.get('HOST', '0.0.0.0') 