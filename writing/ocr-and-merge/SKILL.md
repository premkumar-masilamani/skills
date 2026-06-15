---
name: ocr-and-merge
description: >-
  Transcribes handwritten text from images in a specified folder and merges the transcriptions into a single markdown file.
---

# OCR and Merge Skill

This skill allows the agent to scan a directory for images containing handwriting, transcribe them using multimodal capabilities, save the transcriptions as text files, and merge the results into a single markdown file.

## Prerequisites

- Access to the target folder containing images (`.jpg`, `.jpeg`, `.png`, `.JPG`, `.JPEG`, `.PNG`).

## Action Steps

### 1. Locate the Target Directory
- Default to `~/Downloads` or ask the user to specify a directory path.
- Expand any tilde (`~`) prefix to resolve the absolute path.
- Verify that the path exists. If not, ask the user for a valid path.

### 2. Find and Sort Images
- Scan the target folder for image files with the following extensions:
  - `*.jpg`, `*.jpeg`, `*.png`
  - `*.JPG`, `*.JPEG`, `*.PNG`
- Sort the list of images alphabetically to ensure correct sequencing.

### 3. Transcribe Images (OCR)
For each image:
- Define the output text file path by changing the extension to `.txt` (e.g. `001.jpeg` becomes `001.txt`).
- Check if the `.txt` file already exists. If it does, skip transcription.
- If it does not exist, call the `view_file` tool on the image path to load it into your context.
- Transcribe the handwritten text:
  - Preserve all original formatting, paragraphs, line breaks, lists, and numbers.
  - Do not edit or summarize the transcribed text.
  - If a word is unclear, write it as `[unclear?]`.
- Save the transcribed text into the `.txt` file using the `write_to_file` tool.

### 4. Merge Transcriptions
After transcribing all images:
- Locate all `.txt` files in the directory.
- Sort them alphabetically.
- Create a markdown file named after the folder (e.g. `Foldername.md`) in the folder's parent directory.
- Read each `.txt` file and write its contents into the markdown file, separating each file's content with newlines.
- Print a completion message when finished.
