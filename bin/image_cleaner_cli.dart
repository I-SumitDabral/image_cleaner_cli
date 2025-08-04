/// Entry point for the Image Cleaner CLI tool.
///
/// This tool helps identify and optionally delete unused images
/// in your Flutter/Dart project's assets directory.
///
/// Usage:
/// ```bash
/// dart run bin/image_cleaner_cli.dart [options] <project_folder>
/// ```
///
/// Options:
/// - `--dry-run` or `-d`: Lists unused images without deleting them.
/// - `--help` or `-h`: Displays usage information.
///
/// If no `<project_folder>` is provided, the current directory is used.
library image_cleaner_cli;

import 'dart:io';
import 'package:image_cleaner_cli/server.dart';
import 'package:image_cleaner_cli/utils/file_utils.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('dry-run',
        abbr: 'd',
        negatable: false,
        help: 'List unused images without deleting anything')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Show usage information');

  final argResults = parser.parse(arguments);
  final restArgs = argResults.rest;

  // If help flag is passed, show usage and exit
  if (argResults['help']) {
    stdout.writeln('🧼 Image Cleaner CLI');
    stdout.writeln(
        'Usage: dart run bin/image_cleaner_cli.dart [options] <project_folder>');
    stdout.writeln('\nOptions:');
    stdout.writeln(parser.usage);
    exit(0);
  }

  // Get folder path from args or fallback to current directory
  final folderPath =
      restArgs.isNotEmpty ? restArgs.first : Directory.current.path;
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
  } else {
    stdout.writeln('🚀 Starting image cleaner preview server...');
    startServer(folderPath);
  }
}
