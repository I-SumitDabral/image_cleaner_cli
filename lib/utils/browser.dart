import 'dart:io';

void openBrowser(String url) {
  if (Platform.isMacOS) {
    Process.run('open', [url]);
  } else if (Platform.isWindows) {
    Process.run('start', [url], runInShell: true);
  } else if (Platform.isLinux) {
    Process.run('xdg-open', [url]);
  }
}
