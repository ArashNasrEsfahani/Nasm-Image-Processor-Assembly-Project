from PIL import Image
import os
import re

def grayscale_text_to_image(text_filename):
    # Read the text file
    with open(text_filename, 'r') as f:
        content = f.read()

    # Use regex to find all grayscale values in the format "value-"
    grayscale_values = re.findall(r'(\d+)-', content)

    # Calculate image dimensions
    total_pixels = len(grayscale_values)
    width = len(content.split('\n')[0].split('-')) - 1  # Number of grayscale values per line
    height = total_pixels // width

    # Create a new image
    img = Image.new('L', (width, height))

    for i, value in enumerate(grayscale_values):
        x = i % width
        y = i // width
        img.putpixel((x, y), int(value))

    # Save the image
    output_filename = os.path.splitext(text_filename)[0] + '_reconstructed.png'
    img.save(output_filename)
    print(f"Image has been reconstructed and saved as {output_filename}")

# Example usage
text_filename = input("Enter the name of the grayscale text file: ")
grayscale_text_to_image(text_filename)
