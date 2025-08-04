# 🧼 image_cleaner_cli

A Dart CLI tool to **detect, preview, and delete unused image assets** from your Flutter project.

Easily identify unused images and clean them up using a local interactive HTML preview!

> ⭐️ If you find this useful, consider giving it a **[GitHub star](https://github.com/I-SumitDabral/image_cleaner_cli)** — it helps others discover the project!

---

### 🎬 Demo

![image_cleaner_cli demo](https://raw.githubusercontent.com/I-SumitDabral/image_cleaner_cli/main/doc-assets/image_cleaner_cli_demo.gif)

> 📸 The CLI detects unused images and spins up a local HTML preview for you to review and delete them safely.

---

### ✅ Features

- 🔍 Detect unused images inside your Flutter project
- 🧪 `--dry-run` mode to safely list images without deleting
- 🌐 Starts a local HTML preview to review and delete unused assets
- 🛠️ Simple CLI interface, no complex setup
- ⚡ Works cross-platform (Windows, macOS, Linux)

---

### 🚀 Installation

Activate from your local clone (or globally if published):

```bash
dart pub global activate --source path .
```

Or run directly from local:

```bash
dart run bin/image_cleaner_cli.dart
```

---

### 📦 Usage

#### Show help

```bash
dart run bin/image_cleaner_cli.dart --help
```

#### Dry run (safe mode – no deletion)

```bash
dart run bin/image_cleaner_cli.dart --dry-run
```

#### Full run (with browser preview and deletion)

```bash
dart run bin/image_cleaner_cli.dart
```

This will:

- Scan your `/assets` folder
- Analyze image usage across Dart files
- Launch a **local HTML page** (typically `http://localhost:8080`)
- Let you preview and **select images for deletion**
- Delete selected images after your confirmation

---

### 🖼️ HTML Preview Flow

1. Run the CLI (without `--dry-run`)
2. A local server opens in your browser (localhost:8080)
3. Unused images are displayed in grid format
4. Select images you want to delete
5. Click the delete button — and done ✅

> 🔐 Safe and manual: No image is deleted unless **you choose** it in the browser.

---

### 💡 Example Output

**Dry run sample:**

```bash
📂 Using folder: /your/flutter/project
🧪 Performing dry run...
🗂️ Found 4 unused images:
 - assets/images/old_logo.png
 - assets/icons/unused_icon.svg
 - assets/images/temp/banner.jpg
 - assets/icons/trash.png
```

---

### 🛠️ CLI Options

| Flag        | Alias | Description                                 |
|-------------|-------|---------------------------------------------|
| `--dry-run` | `-d`  | List unused images without deleting them    |
| `--help`    | `-h`  | Show help and usage information             |

---

### 📁 Project Expectations

This tool assumes:

- You use a Flutter project
- Image assets are stored inside the `assets/` folder
- Images are referenced directly via strings in your Dart files

---

### 📌 Version

**Current Version:** `0.0.2`

---

### 🔗 Repository

[GitHub – image_cleaner_cli](https://github.com/I-SumitDabral/image_cleaner_cli)

---

### 👨‍💻 Maintainer

Built with ❤️ by [Sumit Dabral](https://github.com/I-SumitDabral)

---

> 💫 If this project helped you, do consider giving it a ⭐️ — it motivates further development!
