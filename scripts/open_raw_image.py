import io
from PIL import Image

with open("/home/caio.santos/Downloads/test_image.jpg", "rb") as f:
    image_bytes = f.read()
    
start_char = b'\r'
index = image_bytes.index(start_char)
result = image_bytes[index+len(start_char):]
print(result[:100])

width = 1344
height = 1024
mode = 'RGB'

image = Image.frombuffer(mode, (width, height), result * 2)
image.show()
