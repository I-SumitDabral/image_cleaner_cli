String generateHtml(List<String> images, Map<String, String> imageSizes) {
  final cards = images.map((name) {
    final imagePath = '/assets/$name';
    final sizeKb = (imageSizes[name] ?? "0");
    return '''
      <div class="card">
        <input type="checkbox" class="img-checkbox" value="$name" />
        <div class="image-wrapper">
          <span class="size-label">$sizeKb</span>
          <img src="$imagePath" alt="$name" />
        </div>
        <div class="actions">
          <span title="$name">$name</span>
          <button onclick="confirmDelete(['$name'])">🗑️</button>
        </div>
      </div>
    ''';
  }).join();

  final controls = images.isEmpty
      ? '<p style="font-size: 18px; color: #555;">📂 No images found in your project.</p>'
      : '''
      <div id="controls">
        <label><input type="checkbox" id="select-all" /> Select All</label>
        <button onclick="bulkDelete()">🗑️ Delete Selected</button>
      </div>
  ''';

  return '''
<!DOCTYPE html>
<html>
<head>
  <title>Asset Viewer</title>
  <link rel="icon" href="data:,">
  <style>
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
    .image-wrapper img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
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
  </style>
</head>
<body>
  <h1>Image Asset Viewer</h1>
  $controls
  <div class="container">
    $cards
  </div>

  <script>
    const selectAll = document.getElementById('select-all');
    if (selectAll) {
      selectAll.addEventListener('change', function() {
        document.querySelectorAll('.img-checkbox').forEach(cb => cb.checked = this.checked);
      });
    }

    function confirmDelete(files) {
      if (confirm('Are you sure you want to delete ' + files.join(', ') + '?')) {
        fetch('/delete', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({ files: files })
        }).then(() => location.reload());
      }
    }

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