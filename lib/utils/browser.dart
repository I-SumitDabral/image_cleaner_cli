import 'dart:io';

/// Opens the given [url] in the system's default web browser.
///
/// This function supports:
/// - **macOS**: uses the `open` command
/// - **Windows**: uses the `start` command with `runInShell: true`
/// - **Linux**: uses the `xdg-open` command
///
/// Example:
/// ```dart
/// openBrowser('https://pub.dev');
/// ```
///
/// Note: This function assumes the appropriate system commands (`open`, `start`, or `xdg-open`)
/// are available in the system's PATH.
void openBrowser(String url) {
  if (Platform.isMacOS) {
    Process.run('open', [url]);
  } else if (Platform.isWindows) {
    Process.run('start', [url], runInShell: true);
  } else if (Platform.isLinux) {
    Process.run('xdg-open', [url]);
  }
}
