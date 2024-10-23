from PIL import Image
import os
import re

def rgb_text_to_image(text_filename):
    # Read the text file
    with open(text_filename, 'r') as f:
        content = f.read()

    # Use regex to find all RGB values in the format "R G B-"
    rgb_values = re.findall(r'(\d+)\s+(\d+)\s+(\d+)-', content)

    # Calculate image dimensions
    total_pixels = len(rgb_values)
    width = len(content.split('\n')[0].split('-')) - 1  # Number of RGB values per line
    height = total_pixels // width

    # Create a new image
    img = Image.new('RGB', (width, height))

    for i, (r, g, b) in enumerate(rgb_values):
        x = i % width
        y = i // width
        img.putpixel((x, y), (int(r), int(g), int(b)))

    # Save the image
    output_filename = os.path.splitext(text_filename)[0] + '_reconstructed.png'
    img.save(output_filename)
    print(f"Image has been reconstructed and saved as {output_filename}")

# Example usage
text_filename = input("Enter the name of the RGB text file: ")
rgb_text_to_image(text_filename)
