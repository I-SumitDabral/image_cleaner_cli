# image_cleaner_cli

A simple CLI tool to find and optionally delete unused images in your Flutter or Dart project assets folder.

## Features

- Scans your project code to detect which images inside the `assets/` folder are unused.
- Offers a dry run mode to list unused images without deleting them.
- Provides a lightweight local server with a web UI to preview and delete unused images interactively.

## Getting Started

### Installation

You can install this CLI tool globally using Dart:

```bash
dart pub global activate image_cleaner_cli
