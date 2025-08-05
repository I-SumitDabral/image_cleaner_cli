# 🧼 image_cleaner_cli

A Dart CLI tool to **detect, preview, and delete unused image assets** in your Flutter project.

Easily identify unused images and clean them up with a **local interactive HTML preview**!

> ⭐ If you find this tool useful, please give it a **[GitHub star](https://github.com/I-SumitDabral/image_cleaner_cli)** to help others discover it!

---

## 🎬 Demo

![image_cleaner_cli demo](https://raw.githubusercontent.com/I-SumitDabral/image_cleaner_cli/main/doc-assets/image_cleaner_cli_demo.gif)

The CLI detects unused images and launches a local HTML page for you to review and selectively delete them.

---

## ✅ Features

- Detect unused images in your Flutter project’s `assets/` folder.
- Dry-run mode (`--dry-run`) to safely list unused images without deleting.
- Launches a local web server with an interactive HTML preview of unused images.
- Select and delete images through a browser UI.
- Cross-platform support: Windows, macOS, Linux.
- Simple CLI usage, no complex setup required.

---

## 🚀 Installation & Usage

### Method 1: Global Activation

Activate the CLI tool globally for easy access anywhere:

dart pub global activate image_cleaner_cli

text

Then run the tool using:

image_cleaner_cli

text

Make sure your Dart Pub cache’s `bin` directory (e.g., `~/.pub-cache/bin`) is in your system PATH.

---

### Installing a Specific Version Globally

Install a specific version globally by specifying the version number:

dart pub global activate image_cleaner_cli <version>

text

Replace `<version>` with the desired version number, for example, `0.0.3`.

---

### Method 2: Run Locally

Run the CLI directly from your project or tool clone without global install:

dart run bin/image_cleaner_cli.dart

text

---

### Running the CLI for a Specific Folder (if supported)

image_cleaner_cli --folder /path/to/your/project

text

Or when running locally:

dart run bin/image_cleaner_cli.dart --folder /path/to/your/project

text

---

## 📦 CLI Options

| Flag        | Alias | Description                               |
|-------------|-------|-------------------------------------------|
| `--dry-run` | `-d`  | List unused images without deleting them  |
| `--help`    | `-h`  | Show help and usage information            |

---

## 🖼️ How It Works

1. Scans the `assets/` folder for images.
2. Analyzes image usage across your Flutter Dart source files.
3. Starts a local server on `http://localhost:8080`.
4. Opens a browser UI showing unused images.
5. Select images and confirm deletion — safe, manual cleanup.

---

## 💡 Example Output

Dry run sample:

📂 Using folder: /your/flutter/project
🧪 Performing dry run...
🗂️ Found 4 unused images:

assets/images/old_logo.png

assets/icons/unused_icon.svg

assets/images/temp/banner.jpg

assets/icons/trash.png

text

---

## 📁 Requirements

- A Flutter project with image assets stored in an `assets/` folder.
- Images referenced as string paths inside Dart code files.

---

## 📌 Version

Current: `0.0.2`

---

## 🔗 Repository

[GitHub – image_cleaner_cli](https://github.com/I-SumitDabral/image_cleaner_cli)

---

## 👨‍💻 Maintainer

Built with ❤️ by [Sumit Dabral](https://github.com/I-SumitDabral)

---

## 📌 Using as a Package Dependency

If you want to use the functionality **programmatically** inside your Flutter or Dart project (not as a CLI), add `image_cleaner_cli` as a dependency in your `pubspec.yaml`:

dependencies:
image_cleaner_cli: ^0.0.2

text

Then run:

dart pub get

text

or

flutter pub get

text

---

> 💫 If this tool helps you, please consider giving it a ⭐️ on GitHub to support continued development!