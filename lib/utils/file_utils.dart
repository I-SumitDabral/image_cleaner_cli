import 'dart:io';

import 'package:path/path.dart' as p;

final assetsDir = Directory('assets');

String formatFileSize(int bytes) {
  if (bytes >= 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else if (bytes >= 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  } else {
    return '$bytes B';
  }
}

// Future<List<String>> getImages(Directory assetsDir) async {
  
//   if (!await assetsDir.exists()) return [];
//   return assetsDir
//       .listSync()
//       .whereType<File>()
//       .where((f) => f.path.endsWith('.png') || f.path.endsWith('.jpg') || f.path.endsWith('.jpeg'))
//       .map((f) => f.uri.pathSegments.last)
//       .toList();
// }

Future<List<String>> getImages(Directory assetsDir, Directory projectRoot) async {
  final allImages = <String>[];
  final usedImages = <String>{};

  await for (final file in assetsDir.list(recursive: true)) {
    if (file is File && _isImage(file.path)) {
      final relativePath = file.path.replaceFirst('${assetsDir.path}/', '');
      allImages.add(relativePath);
    }
  }

  // Only scan lib folder for code references
  final libDir = Directory(p.join(projectRoot.path, 'lib'));

  if (!await libDir.exists()) {
    print('⚠️ Warning: lib folder does not exist: ${libDir.path}');
    return allImages; // Return all images (considered unused)
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

  final unusedImages = allImages.where((img) => !usedImages.contains(img)).toList();
  return unusedImages;
}


bool _isImage(String path) {
  final lower = path.toLowerCase();
  return lower.endsWith('.png') ||
         lower.endsWith('.jpg') ||
         lower.endsWith('.jpeg') ||
         lower.endsWith('.webp') ||
         lower.endsWith('.gif') ||
         lower.endsWith('.svg');
}

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
