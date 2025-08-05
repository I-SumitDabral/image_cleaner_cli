import 'dart:convert';
import 'dart:io';
import 'package:image_cleaner_cli/utils/browser.dart';
import 'package:image_cleaner_cli/utils/file_utils.dart';
import 'package:image_cleaner_cli/utils/html_renderer.dart';
final int port = 8080;
/// Starts a local HTTP server that serves and manages images in the "assets" folder
/// located inside the given [folderPath].
///
/// - Serves images at `/assets/{filename}`
/// - Serves a simple HTML UI for preview and deletion
/// - Handles POST `/delete` requests to remove selected images from disk
///
/// Automatically opens the browser to preview the UI.
Future<void> startServer(String folderPath) async {
  final assetsDir = Directory('$folderPath/assets'); // use passed folder path
  print(':rocket: Scanning folder: ${assetsDir.path}');
  if (!await assetsDir.exists()) {
    print(':x: No "assets" folder found at ${assetsDir.path}');
    exit(1);
  }
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print(':rocket: Server running at http://localhost:$port');
  openBrowser('http://localhost:$port');
  await for (HttpRequest request in server) {
    final path = request.uri.path;
    print(path);
    // Serve image files from assets
    if (path.startsWith('/assets/')) {
      // Always treat this as a path RELATIVE to assetsDir
      final relative = path.replaceFirst('/assets/', '');
      final file = File('${assetsDir.path}${Platform.pathSeparator}$relative');
      if (await file.exists()) {
        request.response.headers.contentType =
            ContentType('image', file.path.endsWith('.jpg') ? 'jpeg' : 'png');
        await request.response.addStream(file.openRead());
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Image not found');
        print(':warning: Image not found: $path');
      }
      await request.response.close();
      continue;
    }
    // Handle image deletion via POST /delete
    if (path == '/delete' && request.method == 'POST') {
      final payload = await utf8.decoder.bind(request).join();
      final data = jsonDecode(payload);
      final files = List<String>.from(data['files']);
      int totalCleared = 0;
      for (final name in files) {
        // Name is RELATIVE to assetsDir
        final file = File('${assetsDir.path}${Platform.pathSeparator}$name');
        if (await file.exists()) {
          final fileSize = file.lengthSync();
          totalCleared += fileSize;
          await file.delete();
          print(":wastebasket: Deleted '$name' (${formatFileSize(fileSize)})");
        } else {
          print(":warning: File '$name' does not exist.");
        }
      }
      final remaining = await getImages(assetsDir, Directory(folderPath));
      final clearedSize = formatFileSize(totalCleared);
      final message = (files.length == 1)
          ? ":wastebasket: '${files.first}' deleted. $clearedSize cleared."
          : remaining.isEmpty
              ? ":broom: All images deleted. $clearedSize cleared."
              : ":wastebasket: ${files.length} images deleted. $clearedSize cleared.";
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'message': message}));
      await request.response.close();
      print(message);
      if (remaining.isEmpty) {
        print(':white_check_mark: All images cleared – shutting down server.');
        print(':broom: Total size cleared: $clearedSize');
        // Optionally stop the server here
        // await server.close();
      }
      continue;
    }
    // Serve the HTML UI with current image list and sizes
    final images = await getImages(assetsDir, Directory(folderPath));
    // Only use relative paths/names from images list
    final imageSizes = {
      for (final name in images)
        name: formatFileSize(
            File('${assetsDir.path}${Platform.pathSeparator}$name')
                .lengthSync())
    };
    request.response.headers.contentType = ContentType.html;
    request.response.write(generateHtml(images, imageSizes));
    await request.response.close();
  }
}
/// Example helper for getImages: returns a list of image paths RELATIVE to assetsDir
///
/// Modify your actual getImages to use similar logic
// Future<List<String>> getImages(Directory assetsDir, Directory rootDir) async {
//   final List<String> imagePaths = [];
//   await for (final entity
//       in assetsDir.list(recursive: true, followLinks: false)) {
//     if (entity is File &&
//         (entity.path.endsWith('.png') ||
//             entity.path.endsWith('.jpg') ||
//             entity.path.endsWith('.jpeg'))) {
//       // We want relative path from assetsDir
//       final relativePath = entity.path
//           .substring(assetsDir.path.length + 1)
//           .replaceAll('\\', '/'); // Normalize for web
//       imagePaths.add(relativePath);
//     }
//   }
//   return imagePaths;
// }






