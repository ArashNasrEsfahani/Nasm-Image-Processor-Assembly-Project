from PIL import Image
import os

def image_to_grayscale_text(image_filename):
    # Open the image file
    img = Image.open(image_filename)

    # Get the dimensions of the image
    width, height = img.size

    # Convert image to grayscale mode
    img = img.convert('L')

    # Create a new text file with the same name as the image but with .txt extension
    output_filename = os.path.splitext(image_filename)[0] + '.txt'

    with open(output_filename, 'w') as f:
        for y in range(height):
            for x in range(width):
                # Get grayscale value for the current pixel
                grayscale_value = img.getpixel((x, y))
                
                # Write grayscale value to the file
                f.write(f"{grayscale_value}-")
            
            # Add a newline after each row
            f.write('\n')

    print(f"Grayscale values have been saved to {output_filename}")

# Example usage
image_filename = input("Enter the name of the image file in the current directory: ")
image_to_grayscale_text(image_filename)
