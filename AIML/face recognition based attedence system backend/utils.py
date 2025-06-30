import os
import face_recognition
import csv
from datetime import datetime
from flask import current_app

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in current_app.config['ALLOWED_EXTENSIONS']

def load_known_faces(photos_folder):
    known_faces = {}
    for filename in os.listdir(photos_folder):
        if filename.endswith('.jpg') or filename.endswith('.jpeg') or filename.endswith('.png'):
            name = os.path.splitext(filename)[0]
            try:
                image = face_recognition.load_image_file(os.path.join(photos_folder, filename))
                encoding = face_recognition.face_encodings(image)[0]
                known_faces[name] = encoding
            except Exception as e:
                print(f"Error loading {filename}: {e}")
    return known_faces

def write_attendance_csv(name):
    now = datetime.now()
    current_date = now.strftime("%Y-%m-%d")
    current_time = now.strftime("%H-%M-%S")
    with open(current_date + '.csv', 'a+', newline='') as csv_file:
        lnwriter = csv.writer(csv_file)
        lnwriter.writerow([name, current_time])

def write_issue_csv(room_number, problem):
    now = datetime.now()
    current_date = now.strftime("%Y-%m-%d")
    with open('issues_' + current_date + '.csv', 'a+', newline='') as csv_file:
        lnwriter = csv.writer(csv_file)
        lnwriter.writerow([current_date, room_number, problem]) 