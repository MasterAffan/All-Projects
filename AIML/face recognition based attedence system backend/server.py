import face_recognition
import cv2
import numpy as np
import csv
from datetime import datetime
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import os
import signal
import logging
from flask_cors import CORS
from config import Config
from utils import allowed_file, load_known_faces, write_attendance_csv, write_issue_csv

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)
logging.basicConfig(level=logging.INFO)

# Ensure the upload folder exists
if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])

# Load known faces
known_faces = load_known_faces(app.config['PHOTOS_FOLDER'])
known_face_encodings = list(known_faces.values())
known_face_names = list(known_faces.keys())
students = known_face_names.copy()

# Handle graceful shutdown
def signal_handler(sig, frame):
    print('Server is shutting down.')
    exit(0)

signal.signal(signal.SIGINT, signal_handler)

@app.route('/mark_attendance', methods=['POST'])
def mark_attendance():
    if 'file' not in request.files:
        logging.warning('No file part in request')
        return jsonify({'message': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        logging.warning('No selected file')
        return jsonify({'message': 'No selected file'}), 400
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        image = face_recognition.load_image_file(filepath)
        face_locations = face_recognition.face_locations(image)
        face_encodings = face_recognition.face_encodings(image, face_locations)
        face_names = []
        for face_encoding in face_encodings:
            matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
            name = ""
            face_distance = face_recognition.face_distance(known_face_encodings, face_encoding)
            best_match_index = np.argmin(face_distance)
            if matches[best_match_index]:
                name = known_face_names[best_match_index]
            face_names.append(name)
            if name in known_face_names and name in students:
                students.remove(name)
                write_attendance_csv(name)
        if face_names:
            logging.info(f'Attendance marked for {", ".join(face_names)}')
            return jsonify({'message': f'Attendance marked for {", ".join(face_names)}'}), 200
        else:
            logging.info('No face identified')
            return jsonify({'message': 'No face identified'}), 200
    else:
        logging.warning('File type not allowed')
        return jsonify({'message': 'File type not allowed'}), 400

@app.route('/report_issue', methods=['POST'])
def report_issue():
    room_number = request.form.get('room_number')
    problem = request.form.get('problem')
    if room_number and problem:
        write_issue_csv(room_number, problem)
        logging.info(f'Issue reported for room {room_number}')
        return jsonify({'message': 'Issue reported successfully!'}), 200
    else:
        logging.warning('Missing room number or problem description')
        return jsonify({'message': 'Missing room number or problem description'}), 400

@app.route('/add_student', methods=['POST'])
def add_student():
    if 'file' not in request.files or 'name' not in request.form:
        logging.warning('Missing file or name in request')
        return jsonify({'message': 'Missing file or name'}), 400
    file = request.files['file']
    name = request.form['name'].strip().lower()
    if file.filename == '' or not name:
        logging.warning('No selected file or name')
        return jsonify({'message': 'No selected file or name'}), 400
    if not allowed_file(file.filename):
        logging.warning('File type not allowed')
        return jsonify({'message': 'File type not allowed'}), 400
    # Save the photo in the photos/ directory
    filename = f"{name}.jpg"
    photo_path = os.path.join(app.config['PHOTOS_FOLDER'], filename)
    file.save(photo_path)
    # Reload known faces
    global known_faces, known_face_encodings, known_face_names, students
    known_faces = load_known_faces(app.config['PHOTOS_FOLDER'])
    known_face_encodings = list(known_faces.values())
    known_face_names = list(known_faces.keys())
    students = known_face_names.copy()
    logging.info(f'Added new student: {name}')
    return jsonify({'message': f'Student {name} added successfully!'}), 200

if __name__ == '__main__':
    app.run(host=app.config['HOST'], port=app.config['PORT'])
