import 'dart:io';
import 'package:image_cleaner_cli/server.dart'; // assumes your server handles the preview + delete
import 'package:image_cleaner_cli/utils/file_utils.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('dry-run', abbr: 'd', negatable: false, help: 'List unused images without deleting anything');

  final argResults = parser.parse(arguments);
  final restArgs = argResults.rest;

  // Get folder path from args or fallback to current directory
  final folderPath = restArgs.isNotEmpty ? restArgs.first : Directory.current.path;
  final directory = Directory(folderPath);

  if (!directory.existsSync()) {
    stderr.writeln('❌ The provided folder path does not exist: $folderPath');
    exit(1);
  }

  stdout.writeln('📂 Using folder: $folderPath');

 if (argResults['dry-run']) {
  stdout.writeln('🧪 Performing dry run...');

  final assetsDir = Directory(p.join(folderPath, 'assets'));
  final projectRootDir = Directory(folderPath);

  final unusedImages = await getImages(assetsDir, projectRootDir);

  if (unusedImages.isEmpty) {
    stdout.writeln('✅ No unused images found.');
  } else {
    stdout.writeln('🗂️ Found ${unusedImages.length} unused images:');
    for (final path in unusedImages) {
      stdout.writeln(' - $path');
    }
  }
}
else {
    stdout.writeln('🚀 Starting image cleaner preview server...');
    startServer(folderPath); // this shows preview + handles user-driven deletion
  }
}
