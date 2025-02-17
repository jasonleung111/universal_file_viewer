UniversalFileViewer - A Flutter package to preview various file types, including images, videos, PDFs, Word, Excel, CSV, and PowerPoint files on Android and iOS.

```
Features✅ Image preview (JPG, PNG, GIF, BMP, TIFF)<br />
✅ Video playback (MP4, AVI, MOV, MKV)<br />
✅ PDF viewer<br />
✅ Word documents (.doc, .docx)<br />
✅ Excel files (.xls, .xlsx)<br />
✅ CSV file preview<br />
✅ PowerPoint files (.ppt, .pptx)<br />
✅ Text files (.txt, .md)<br />
✅ Fallback to external app if unsupported<br />
```

##Installation

Add this package to your pubspec.yaml:
```
dependencies:
  universal_file_viewer: latest_versionThen, 

```
run:
flutter pub get

Usage

Import the packageimport 'package:universal_file_viewer/universal_file_viewer.dart';

Basic UsageUniversalFileViewer(filePath: '/path/to/your/file');

Example
```
import 'package:flutter/material.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';
```
void main() {
  runApp(MyApp());
}
```
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

```
File Type Detection<br />

Internally, the package determines the file type based on its extension:
```
FileType detectFileType(String path);
```
Supported File FormatsImages: .jpg, .jpeg, .png, .gif, .bmp, .tiff<br />
Videos: .mp4, .avi, .mov, .mkv<br />
Documents: .pdf, .doc, .docx, .xls, .xlsx, .ppt, .pptx, .csv, .txt, .md<br />

DependenciesThis package leverages:<br />

file_picker for file selection<br />
open_filex for opening unsupported files in external apps<br />
video_player for video playback<br />
syncfusion_flutter_pdfviewer for PDF preview<br />
flutter_office_viewer for Word, Excel, and PowerPoint files<br />


##Future Enhancements<br />
✅ More file format support<br />
✅ Web support<br />
✅ Better UI customization<br />
✅ Encrypted file handling<br />


LicenseThis project is licensed under the MIT License - see the LICENSE file for details.
ContributingContributions are welcome! Feel free to submit issues and pull requests.
⭐ If you like this package, consider giving it a star on [Github](https://github.com/Shonu72/universal_file_viewer) 🚀
