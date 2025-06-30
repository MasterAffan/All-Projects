# Face Recognition Attendance & Issue Reporting Server

This project is a Flask-based server for face recognition-based attendance marking and issue reporting, with emotion detection using DeepFace.

## Features
- Mark attendance by uploading a photo (face recognition + emotion detection)
- Report issues (room number + problem)
- Stores attendance and issues in CSV files
- CORS enabled for frontend integration
- Industry-standard structure and error handling

## Setup
1. Clone the repository
2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```
3. Place known face images in the `photos/` directory (filenames should be the person's name, e.g., `john.jpg`)
4. Run the server:
   ```
   python server.py
   ```

## API Endpoints

### `POST /mark_attendance`
- Form-data: `file` (image file)
- Response: Attendance marked with detected names and emotions

### `POST /report_issue`
- Form-data: `room_number`, `problem`
- Response: Issue logged in CSV

### `POST /add_student`
- Form-data: `name` (student's name), `file` (student's photo)
- Saves the photo in the `photos/` directory and adds the student to the system
- Response: Success or error message

**Example:**
```sh
curl -X POST -F "name=John Doe" -F "file=@/path/to/photo.jpg" http://localhost:5000/add_student
```

## Configuration
- Edit `config.py` or use environment variables for custom settings (upload folder, port, etc.)

## Project Structure
- `server.py` - Main Flask app
- `config.py` - Configuration
- `utils.py` - Helper functions
- `photos/` - Known faces
- `uploads/` - Uploaded images

## License
MIT 