UniversalFileViewer

A Flutter package to preview various file types, including images, videos, PDFs, Word, Excel, CSV, and PowerPoint files on Android and iOS.

Features
```
✅ Image preview (JPG, PNG, GIF, BMP, TIFF)
✅ Video playback (MP4, AVI, MOV, MKV)
✅ PDF viewer✅ Word documents (.doc, .docx)
✅ Excel files (.xls, .xlsx)
✅ CSV file preview
✅ PowerPoint files (.ppt, .pptx)
✅ Text files (.txt, .md)
✅ Fallback to external app if unsupported

Installation
Add this package to your pubspec.yaml:
```
dependencies:
  universal_file_viewer: latest_version

Run
```
flutter pub get

Usage
```
Import the packageimport 'package:universal_file_viewer/universal_file_viewer.dart';

Basic Usage
```
UniversalFileViewer(filePath: '/path/to/your/file');

Example
```
import 'package:flutter/material.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Universal File Viewer')),
        body: Center(
          child: UniversalFileViewer(filePath: '/storage/emulated/0/Download/sample.pdf'),
        ),
      ),
    );
  }
}

File Type Detection

Internally, the package determines the file type based on its extension:

```
FileType detectFileType(String path);

Supported file formats:
Images: .jpg, .jpeg, .png, .gif, .bmp, .tiff
Videos: .mp4, .avi, .mov, .mkv
Documents: .pdf, (more to come in future)


Dependencies

This package leverages: 
file_picker for file selection
open_filex for opening unsupported files in external apps
video_player for video playback
syncfusion_flutter_pdfviewer for PDF preview
flutter_office_viewer for Word, Excel, and PowerPoint files

Future Enhancements
✅ More file supports
✅ Web support
✅ Better UI customization
✅ Encrypted file handling


LicenseThis project is licensed under the MIT License - see the LICENSE file for details.
ContributingContributions are welcome! Feel free to submit issues and pull requests.
⭐ If you like this package, consider giving it a star on [GitHub](https://github.com/Shonu72/universal_file_viewer)! 🚀
