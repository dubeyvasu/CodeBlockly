from flask import Flask, request, jsonify
from flask_cors import CORS
import whisper
import os
import wave
from werkzeug.utils import secure_filename
import shutil

app = Flask(__name__)
CORS(app)

# Configure paths for Windows
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, 'temp_audio')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
ALLOWED_EXTENSIONS = {'wav', 'mp3', 'm4a', 'ogg'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def validate_wav_file(file_path):
    try:
        with wave.open(file_path, 'rb') as wave_file:
            print(f"WAV file details:")
            print(f"Number of channels: {wave_file.getnchannels()}")
            print(f"Sample width: {wave_file.getsampwidth()}")
            print(f"Frame rate: {wave_file.getframerate()}")
            print(f"Number of frames: {wave_file.getnframes()}")
            return True
    except Exception as e:
        print(f"Error validating WAV file: {str(e)}")
        return False

# Load the Whisper model
try:
    print("Loading Whisper model...")
    model = whisper.load_model("base")
    print("Whisper model loaded successfully")
except Exception as e:
    print(f"Error loading Whisper model: {str(e)}")
    model = None

@app.route('/transcribe', methods=['POST'])
def transcribe_audio():
    print("\n=== New Transcription Request ===")
    print(f"Current working directory: {os.getcwd()}")
    print(f"Upload folder: {UPLOAD_FOLDER}")
    
    # Ensure upload directory exists
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)

    if 'audio' not in request.files:
        print("No audio file found in request.files")
        print(f"Request files keys: {list(request.files.keys())}")
        return jsonify({"error": "No audio file provided"}), 400

    audio_file = request.files['audio']
    print(f"Received file: {audio_file.filename}")
    
    if audio_file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if not allowed_file(audio_file.filename):
        return jsonify({"error": f"File type not supported. Allowed types: {ALLOWED_EXTENSIONS}"}), 400

    try:
        # Secure the filename and create full path
        filename = secure_filename(audio_file.filename)
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        
        print(f"Saving file to: {file_path}")
        audio_file.save(file_path)
        
        # Verify file was saved
        if not os.path.exists(file_path):
            print(f"Failed to save file to {file_path}")
            return jsonify({"error": "Failed to save audio file"}), 500
        
        file_size = os.path.getsize(file_path)
        print(f"File saved successfully. Size: {file_size} bytes")
        
        if file_size == 0:
            os.remove(file_path)
            return jsonify({"error": "Uploaded file is empty"}), 400

        # Validate WAV file (if applicable)
        if filename.lower().endswith('.wav'):
            if not validate_wav_file(file_path):
                return jsonify({"error": "Invalid WAV file format"}), 400

        # Perform transcription using Whisper
        if model is None:
            print("Whisper model not loaded.")
            return jsonify({"error": "Whisper model is not loaded"}), 500

        print(f"Starting transcription for file: {file_path}")
        
        try:
            result = model.transcribe(file_path)
            transcription_text = result['text'].strip()
            
            print(f"Transcription successful: {transcription_text}")
            
            return jsonify({
                "transcription": transcription_text,
                "status": "success"
            })
            
        except Exception as e:
            error_msg = f"Transcription error: {str(e)}"
            print(error_msg)
            return jsonify({"error": error_msg}), 500
        
        finally:
            # Clean up temporary file in finally block to ensure it happens
            try:
                if os.path.exists(file_path):
                    os.remove(file_path)
                    print(f"Cleaned up temporary file: {file_path}")
            except Exception as e:
                print(f"Error during cleanup: {str(e)}")

    except Exception as e:
        error_msg = f"File processing error: {str(e)}"
        print(error_msg)
        return jsonify({"error": error_msg}), 500

if __name__ == '__main__':
    # Ensure upload directory exists and is empty
    if os.path.exists(UPLOAD_FOLDER):
        shutil.rmtree(UPLOAD_FOLDER)
    os.makedirs(UPLOAD_FOLDER)
    
    print(f"Server initialized:")
    print(f"- Upload directory: {UPLOAD_FOLDER}")
    print(f"- Current working directory: {os.getcwd()}")
    print(f"- Allowed file types: {ALLOWED_EXTENSIONS}")
    
    app.run(host="0.0.0.0", port=5000, debug=True)
