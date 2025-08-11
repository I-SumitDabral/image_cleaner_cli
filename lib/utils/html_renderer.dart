import 'dart:io';

/// Generates an HTML page displaying image assets in a card-based layout.
///
/// This HTML is meant to be served via a local server for asset review and cleanup.
/// It includes features like:
/// - Select All
/// - Delete Selected (bulk delete)
/// - Individual delete buttons
/// - Image size display
/// - Special handling for SVG files (inline rendering to avoid path/MIME issues)
///
/// Parameters:
/// - [images]: List of image file names (e.g., ['logo.png']).
/// - [imageSizes]: A map of image file names to their size strings (e.g., {'logo.png': '120 KB'}).
/// - [absDirectoryPath]: Absolute path to the directory containing images (for reading SVG content).
/// - [relDirectoryPath]: Relative path (from the HTML file) to the directory for normal <img> tags.
///
/// Returns: A complete HTML document as a string.
String generateHtml(
  List<String> images,
  Map<String, String> imageSizes,
  String absDirectoryPath, // e.g. "/Users/.../project/assets/"
  String relDirectoryPath, // e.g. "/assets/"
) {
  // Generate individual image cards with checkboxes, preview, and delete button
  final cards = images.map((name) {
    final sizeKb = (imageSizes[name] ?? "0");

    // Special handling for SVG files — read contents and inline them
    if (name.toLowerCase().endsWith('.svg')) {
      try {
        // Read the SVG file contents directly from the absolute path
        final svgContent = File('$absDirectoryPath$name').readAsStringSync();
        return '''
          <div class="card">
            <input type="checkbox" class="img-checkbox" value="$name" />
            <div class="image-wrapper">
              <span class="size-label">$sizeKb</span>
              $svgContent
            </div>
            <div class="actions">
              <span title="$name">$name</span>
              <button onclick="confirmDelete(['$name'])">🗑️</button>
            </div>
          </div>
        ''';
      } catch (e) {
        // If reading fails (missing file, etc.), fallback to normal <img> rendering
        return '''
          <div class="card">
            <input type="checkbox" class="img-checkbox" value="$name" />
            <div class="image-wrapper">
              <span class="size-label">$sizeKb</span>
              <img src="$relDirectoryPath$name" alt="$name" />
            </div>
            <div class="actions">
              <span title="$name">$name</span>
              <button onclick="confirmDelete(['$name'])">🗑️</button>
            </div>
          </div>
        ''';
      }
    } else {
      // Non-SVG images use standard <img> tags with the relative path
      return '''
        <div class="card">
          <input type="checkbox" class="img-checkbox" value="$name" />
          <div class="image-wrapper">
            <span class="size-label">$sizeKb</span>
            <img src="$relDirectoryPath$name" alt="$name" />
          </div>
          <div class="actions">
            <span title="$name">$name</span>
            <button onclick="confirmDelete(['$name'])">🗑️</button>
          </div>
        </div>
      ''';
    }
  }).join();

  // Show controls only if there are images
  final controls = images.isEmpty
      ? '<p style="font-size: 18px; color: #555;">📂 No images found in your project.</p>'
      : '''
      <div id="controls">
        <label><input type="checkbox" id="select-all" /> Select All</label>
        <button onclick="bulkDelete()">🗑️ Delete Selected</button>
      </div>
  ''';

  // Final HTML output including styles, JS logic, and loader
  return '''
<!DOCTYPE html>
<html>
<head>
  <title>Image Cleaner Asset Viewer</title>
  <link rel="icon" href="data:,">
  <style>
    /* Basic layout and card styles */
    body {
      font-family: sans-serif;
      padding: 20px;
      background: #f4f4f4;
    }
    h1 {
      margin-bottom: 10px;
    }
    .container {
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
    }
    .card {
      background: white;
      border-radius: 12px;
      width: 200px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      position: relative;
    }
    .image-wrapper {
      width: 100%;
      height: 160px;
      overflow: hidden;
      border-radius: 12px 12px 0 0;
      position: relative;
    }
    .image-wrapper img, .image-wrapper svg {
      width: 100%;
      height: 100%;
      object-fit: contain;
      display: block;
      background: #fafafa;
    }
    .size-label {
      position: absolute;
      top: 6px;
      right: 8px;
      background: rgba(0,0,0,0.6);
      color: white;
      font-size: 12px;
      padding: 2px 6px;
      border-radius: 4px;
    }
    .card input[type="checkbox"] {
      position: absolute;
      margin: 10px;
      z-index: 2;
    }
    .actions {
      padding: 10px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 6px;
    }
    .actions span {
      font-size: 14px;
      word-break: break-word;
      flex: 1;
    }
    button {
      background: black;
      color: white;
      border: none;
      padding: 4px 8px;
      border-radius: 5px;
      cursor: pointer;
      flex-shrink: 0;
      display: flex;
      align-items: center;
      gap: 4px;
    }
    button:hover {
      background: #333;
    }
    #controls {
      margin-bottom: 12px;
      display: flex;
      gap: 10px;
      align-items: center;
    }

    /* Fullscreen loader for delete action */
    #loader {
      position: fixed;
      top: 0;
      left: 0;
      height: 100vh;
      width: 100vw;
      background: rgba(255,255,255,0.7);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      z-index: 9999;
      display: none;
    }
  </style>
</head>
<body>
  <div id="loader">⏳ Deleting, please wait...</div>

  <h1>Image Asset Viewer</h1>
  $controls
  <div class="container">
    $cards
  </div>

  <script>
    // Toggle all checkboxes when "Select All" is clicked
    const selectAll = document.getElementById('select-all');
    if (selectAll) {
      selectAll.addEventListener('change', function() {
        document.querySelectorAll('.img-checkbox').forEach(cb => cb.checked = this.checked);
      });
    }

    // Show loader when deleting
    function showLoader() {
      document.getElementById('loader').style.display = 'flex';
    }

    // Delete a single image or multiple
    function confirmDelete(files) {
      if (confirm('Are you sure you want to delete ' + files.join(', ') + '?')) {
        showLoader();
        fetch('/delete', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ files: files })
        }).then(() => location.reload());
      }
    }

    // Collect selected images and call confirmDelete
    function bulkDelete() {
      const files = [...document.querySelectorAll('.img-checkbox')]
                      .filter(cb => cb.checked)
                      .map(cb => cb.value);
      if (files.length === 0) {
        alert('No files selected.');
        return;
      }
      confirmDelete(files);
    }
  </script>
</body>
</html>
''';
}
