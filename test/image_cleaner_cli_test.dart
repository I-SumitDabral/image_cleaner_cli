import 'dart:io';

import 'package:image_cleaner_cli/utils/file_utils.dart' as cli;
import 'package:test/test.dart';

void main() {
  group('CLI Tests', () {
    late Directory tempDir;
    late Directory assetsDir;
    late Directory codeDir;

    setUp(() async {
      // Create temp dirs for assets and code
      tempDir = await Directory.systemTemp.createTemp('image_cleaner_test');
      assetsDir = Directory('${tempDir.path}/assets')
        ..createSync(recursive: true);
      codeDir = Directory('${tempDir.path}/lib')..createSync(recursive: true);

      // Create sample images
      File('${assetsDir.path}/used.png').writeAsStringSync('fakeimagecontent');
      File('${assetsDir.path}/unused.png')
          .writeAsStringSync('fakeimagecontent');

      // Create sample Dart code referencing only 'used.png'
      File('${codeDir.path}/main.dart').writeAsStringSync("""
        void main() {
          print('Image: assets/used.png');
        }
      """);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('getImages returns only unused images', () async {
      final unused = await cli.getImages(assetsDir, tempDir);
      expect(unused, contains('unused.png'));
      expect(unused, isNot(contains('used.png')));
    });

    // More tests can be added for arg parsing, dry run output, etc.
  });
}
