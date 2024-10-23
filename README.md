# Nasm-Image-Processor-Assembly-Project

A powerful image processing tool implemented in NASM assembly language, demonstrating high-performance image manipulation at the lowest level.

![NASM](https://img.shields.io/badge/NASM-x86__64-red.svg)
![Python](https://img.shields.io/badge/python-3.6+-blue.svg)
![Pillow](https://img.shields.io/badge/pillow-8.0+-blue.svg)

## 📝 Table of Contents
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Usage](#-usage)
- [Image Processing Operations](#-image-processing-operations)
- [Technical Implementation](#-technical-implementation)
- [Project Structure](#-project-structure)

## ✨ Features
- **Color Channel Manipulation**:
  - Selective channel removal (RGB)
  - Grayscale conversion
- **Image Transformation**:
  - Custom resize operations
  - Noise effects generation
- **High Performance**:
  - Assembly-level optimization
  - Efficient memory management
- **Cross-Format Support**:
  - Text-to-image conversion
  - Image-to-text conversion
- **Interactive Interface**:
  - User-friendly command prompts
  - Multiple processing options

## 🔧 Prerequisites
- NASM Assembler
- Python 3.6+
- Pillow (Python Imaging Library)
- Linux/Unix environment


## 💻 Usage
1. **Convert Image to Text**
```bash
# For color images
python src/python/color_to_text.py input_image.jpg

# For B&W images
python src/python/bw_to_text.py input_image.jpg
```

2. **Process Image**
```bash
./image_processor
```

3. **Convert Back to Image**
```bash
# For color images
python src/python/text_to_color.py

# For B&W images
python src/python/text_to_bw.py
```

## 🎨 Image Processing Operations
1. **Reshape (Color Channel Manipulation)**
   - Remove specific color channels
   - Adjust color composition

2. **Resize**
   - Scale images to desired dimensions
   - Maintain aspect ratio option

3. **Add Noise**
   - Salt and pepper noise generation
   - Random noise distribution

## 🔧 Technical Implementation
- **Assembly Optimization**
  - Register-level operations
  - Efficient memory access
  - System call optimization

- **File Operations**
  - Direct file I/O handling
  - Buffered reading/writing
  - Error handling


## 📁 Project Structure
```
├── assembly/
│   └── image_processor.asm    # Core assembly implementation
│
└── python/
  ├── bw_to_text.py         # B&W image to text converter
  ├── text_to_bw.py         # Text to B&W image converter
  ├── color_to_text.py      # Color image to text converter
  └── text_to_color.py      # Text to color image converter
│
├── examples/
```
