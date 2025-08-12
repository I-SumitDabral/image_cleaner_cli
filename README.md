
# 🧼 image_cleaner_cli

**A Dart CLI tool to detect, preview, and delete unused image assets in your Flutter project.**

Clean up your codebase with an interactive, browser-based preview of unused images.

> ⭐ Found this helpful? Give it a **[star on GitHub](https://github.com/I-SumitDabral/image_cleaner_cli)**!

---

## 🎬 Demo

![image_cleaner_cli demo](https://raw.githubusercontent.com/I-SumitDabral/image_cleaner_cli/main/doc-assets/image_cleaner_cli_demo.gif)

---

## ✅ Features

- 🔍 Detect unused images in your Flutter project's `assets/` folder  
- 🧪 **Dry-run mode** (`--dry-run`) to preview without deleting  
- 🌐 Automatically launches a **local interactive HTML preview**  
- 🗑️ Delete selected images directly via the browser UI  
- 💻 Works on **macOS**, **Windows**, and **Linux**  
- ⚙️ **Simple CLI**, no setup or config required

---

## 🚀 Installation

### 📦 Global Activation

```bash
dart pub global activate image_cleaner_cli
```

Then run the tool from anywhere:

```bash
image_cleaner_cli
```

> 🔁 Make sure your Dart `bin` path (e.g., `~/.pub-cache/bin`) is in your system's `PATH`.

---

### 📌 Installing a Specific Version

```bash
dart pub global activate image_cleaner_cli <version>
```

_Example:_

```bash
dart pub global activate image_cleaner_cli 0.0.3
```

---

### ▶️ Run Locally Without Global Install

Clone or open your local project and run:

```bash
dart run bin/image_cleaner_cli.dart
```

---

### 📂 Scan a Specific Project Folder

```bash
image_cleaner_cli --folder /path/to/your/flutter/project
```

Or, when running locally:

```bash
dart run bin/image_cleaner_cli.dart --folder /path/to/your/flutter/project
```

---
▶️ Usage
Arguments:

css
Copy
Edit
  <project_folder>
    Path to your Flutter/Dart project root or to a specific assets/images folder.
    You can pass either a relative or absolute path.
Examples:

bash
Copy
Edit
dart run bin/image_cleaner_cli.dart example/assets
dart run bin/image_cleaner_cli.dart example/images
dart run bin/image_cleaner_cli.dart example
If omitted, the current working directory will be used.

By default, the tool checks for an assets/ folder; if none is found, it checks for an images/ folder.
If you want to scan a custom folder, pass it as an argument:

bash
Copy
Edit
dart run bin/image_cleaner_cli.dart -- example/customFolder

## ⚙️ CLI Options

| Flag          | Alias | Description                                |
|---------------|-------|--------------------------------------------|
| `--dry-run`   | `-d`  | Preview unused images (no deletion)        |
| `--folder`    |       | Set root directory to scan (optional)      |
| `--help`      | `-h`  | Display help and usage info                |

---

## 🛠 How It Works

1. Scans your `assets/` and `images/` directory.
2. Finds image files not referenced in any `.dart` files.
3. Starts a local web server (`http://localhost:8080`).
4. Opens an interactive UI where you can:
   - ✅ Review all unused images.
   - 🗑️ Select and delete them safely with a single click.

---

## 💡 Sample Output (Dry Run)

```
📂 Using folder: /your/flutter/project
🧪 Performing dry run...
🗂️ Found 4 unused images:

  assets/images/old_logo.png
  assets/icons/unused_icon.svg
  assets/images/temp/banner.jpg
  assets/icons/trash.png
```

---

## 📁 Requirements

- Flutter project with images stored under `assets/`
- Image paths must be referenced directly in `.dart` files as strings (no dynamic paths)

---

## 📌 Version

**Current:** `0.0.4`  
Check [pub.dev → image_cleaner_cli](https://pub.dev/packages/image_cleaner_cli) for latest.

---

## 👨‍💻 Maintainer

Built with ❤️ by [Sumit Dabral](https://github.com/I-SumitDabral)

---

## 🔗 GitHub

[github.com/I-SumitDabral/image_cleaner_cli](https://github.com/I-SumitDabral/image_cleaner_cli)

---

## 🧰 Use as a Dart Package

You can also use `image_cleaner_cli` **programmatically** in your project:

### In `pubspec.yaml`

```yaml
dependencies:
  image_cleaner_cli: ^0.0.4
```

### Then run:

```bash
dart pub get
# or
flutter pub get
```

---

## 🔖 Tags

```
flutter
dart
cli
image-cleaner
asset-cleaner
flutter-cli
flutter-asset
tooling
developer-tools
```

---

## 🙌 Support

If this CLI saves you time and clutter, please consider:

- ⭐ Starring the project on [GitHub](https://github.com/I-SumitDabral/image_cleaner_cli)
- 📢 Sharing it with fellow developers
- 🐛 Reporting issues or suggesting features

## 📦 image_cleaner_cli

[![Pub Version](https://img.shields.io/pub/v/image_cleaner_cli.svg)](https://pub.dev/packages/image_cleaner_cli)
[![Pub Points](https://img.shields.io/pub/points/image_cleaner_cli.svg)](https://pub.dev/packages/image_cleaner_cli/score)
[![Likes](https://img.shields.io/pub/likes/image_cleaner_cli.svg)](https://pub.dev/packages/image_cleaner_cli)
[![GitHub Stars](https://img.shields.io/github/stars/I-SumitDabral/image_cleaner_cli.svg?style=social&label=Star)](https://github.com/I-SumitDabral/image_cleaner_cli)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/I-SumitDabral/image_cleaner_cli/blob/main/LICENSE)

<!-- Optional Badges -->
[![Build Status](https://github.com/I-SumitDabral/image_cleaner_cli/actions/workflows/build.yml/badge.svg)](https://github.com/I-SumitDabral/image_cleaner_cli/actions)
[![Code Coverage](https://codecov.io/gh/I-SumitDabral/image_cleaner_cli/branch/main/graph/badge.svg)](https://codecov.io/gh/I-SumitDabral/image_cleaner_cli)

