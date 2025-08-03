import 'dart:convert';
import 'dart:io';

import 'package:image_cleaner_cli/utils/browser.dart';
import 'package:image_cleaner_cli/utils/file_utils.dart';
import 'package:image_cleaner_cli/utils/html_renderer.dart';

final int port = 8080;
final assetsDir = Directory('assets');



Future<void> startServer(String folderPath) async {
  final assetsDir = Directory('$folderPath/assets'); // 👈 use passed folder path
  print('🚀 Scanning folder: ${assetsDir.path}');

  if (!await assetsDir.exists()) {
    print('❌ No "assets" folder found at ${assetsDir.path}');
    exit(1);
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('🚀 Server running at http://localhost:$port');
  openBrowser('http://localhost:$port');

  await for (HttpRequest request in server) {
    final path = request.uri.path;

    // Serve image files
    if (path.startsWith('/assets/')) {
      final relative = path.replaceFirst('/assets/', '');
      final file = File('${assetsDir.path}/$relative');
      if (await file.exists()) {
        request.response.headers.contentType =
            ContentType('image', file.path.endsWith('.jpg') ? 'jpeg' : 'png');
        await request.response.addStream(file.openRead());
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Image not found');
        print('⚠️ Image not found: $path');
      }
      await request.response.close();
      continue;
    }

    // Delete image handler
    if (path == '/delete' && request.method == 'POST') {
      final payload = await utf8.decoder.bind(request).join();
      final data = jsonDecode(payload);
      final files = List<String>.from(data['files']);

      int totalCleared = 0;
      for (final name in files) {
        final file = File('${assetsDir.path}/$name');
        if (await file.exists()) {
          final fileSize = file.lengthSync();
          totalCleared += fileSize;
          await file.delete();
          print("🗑️ Deleted '$name' (${formatFileSize(fileSize)})");
        } else {
          print("⚠️ File '$name' does not exist.");
        }
      }

      final remaining = await getImages(assetsDir, Directory(folderPath));
      final clearedSize = formatFileSize(totalCleared);
      final message = (files.length == 1)
          ? "🗑️ '${files.first}' deleted. $clearedSize cleared."
          : remaining.isEmpty
              ? "🧹 All images deleted. $clearedSize cleared."
              : "🗑️ ${files.length} images deleted. $clearedSize cleared.";

      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'message': message}));
      await request.response.close();

      print(message);

      if (remaining.isEmpty) {
        print('✅ All images cleared – shutting down server.');
        print('🧹 Total size cleared: $clearedSize');
      }

      continue;
    }

    // Serve HTML
    final images = await getImages(assetsDir, Directory(folderPath));
    final imageSizes = {
      for (final name in images)
        name: formatFileSize(File('${assetsDir.path}/$name').lengthSync())
    };

    request.response.headers.contentType = ContentType.html;
    request.response.write(generateHtml(images, imageSizes));
    await request.response.close();
  }
}
