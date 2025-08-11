import 'dart:io';
import 'package:path/path.dart' as p;

/// A reference to the default assets directory (`assets/`).
final assetsDir = Directory('assets');

/// Formats a file size [bytes] into a human-readable string.
String formatFileSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else if (bytes >= 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  } else {
    return '$bytes B';
  }
}

/// Scans [assetsDir] for image files and returns a list of image paths
/// that are **not referenced** in any `.dart`, `.yaml`, `.json`, or `.html`
/// files inside the `lib/` folder of the [projectRoot].
Future<List<String>> getImages(
    Directory assetsDir, Directory projectRoot) async {
  final allImages = <String>[];
  final usedImages = <String>{};

  // Folders to exclude (top-level or nested)
  final excludeDirs = {
    'build',
    'android',
    'ios',
    'web',
    'macos',
    'linux',
    'windows',
  };

  await for (final file in assetsDir.list(recursive: true)) {
    if (file is File && _isImage(file.path)) {
      // Skip if path contains any excluded folder name
      final parts = file.path.split(Platform.pathSeparator);
      if (parts.any((p) => excludeDirs.contains(p))) {
        continue;
      }

      // Use package:path to get the relative path from assetsDir
      final relativePath = p
          .relative(file.path, from: assetsDir.path)
          .replaceAll('\\', '/'); // Normalize separators to '/'
      allImages.add(relativePath);
    }
  }

  Directory updatedDataDirectory = Directory(projectRoot.path);
  if (projectRoot.path.contains("/")) {
    updatedDataDirectory = Directory(
        projectRoot.path.replaceAll("/assets", "").replaceAll("/images", ''));
  }
  final libDir = Directory(p.join(updatedDataDirectory.path, 'lib'));

  if (!await libDir.exists()) {
    print('⚠️ Warning: lib folder does not exist: ${libDir.path}');
    return allImages;
  }

  final codeFiles = await _getAllCodeFiles(libDir);

  for (final file in codeFiles) {
    try {
      final content = await file.readAsString();
      for (final image in allImages) {
        if (content.contains(image)) {
          usedImages.add(image);
        }
      }
    } catch (e) {
      // Ignore unreadable files
    }
  }

  final unusedImages =
      allImages.where((img) => !usedImages.contains(img)).toList();
  return unusedImages;
}

/// Checks if the file at [path] is a supported image type.
bool _isImage(String path) {
  final lower = path.toLowerCase();
  return lower.endsWith('.png') ||
      lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.gif') ||
      lower.endsWith('.svg');
}

/// Recursively collects all relevant code files from [root] directory,
/// including `.dart`, `.yaml`, `.json`, and `.html`.
Future<List<File>> _getAllCodeFiles(Directory root) async {
  final codeFiles = <File>[];

  await for (final file in root.list(recursive: true)) {
    if (file is File &&
        (file.path.endsWith('.dart') ||
            file.path.endsWith('.yaml') ||
            file.path.endsWith('.json') ||
            file.path.endsWith('.html'))) {
      codeFiles.add(file);
    }
  }

  return codeFiles;
}
