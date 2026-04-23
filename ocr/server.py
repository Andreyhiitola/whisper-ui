from flask import Flask, request, jsonify
import base64
import pytesseract
from PIL import Image
import io

app = Flask(__name__)

@app.route('/ocr', methods=['POST'])
def ocr():
    data = request.get_json()
    if not data or 'image' not in data:
        return jsonify({'error': 'no image'}), 400
    try:
        img_data = base64.b64decode(data['image'])
        img = Image.open(io.BytesIO(img_data))
        text = pytesseract.image_to_string(img, lang='rus+eng', config='--psm 3')
        return jsonify({'text': text.strip()})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
