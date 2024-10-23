from PIL import Image
import os

def image_to_rgb_text(image_filename):
    # Open the image file
    img = Image.open(image_filename)

    # Get the dimensions of the image
    width, height = img.size

    # Convert image to RGB mode if it's not already
    img = img.convert('RGB')

    # Create a new text file with the same name as the image but with .txt extension
    output_filename = os.path.splitext(image_filename)[0] + '.txt'

    with open(output_filename, 'w') as f:
        for y in range(height):
            for x in range(width):
                # Get RGB values for the current pixel
                r, g, b = img.getpixel((x, y))
                
                # Write RGB values to the file
                f.write(f"{r} {g} {b}-")
            
            # Add a newline after each row
            f.write('\n')

    print(f"RGB values have been saved to {output_filename}")

# Example usage
image_filename = input("Enter the name of the image file in the current directory: ")
image_to_rgb_text(image_filename)