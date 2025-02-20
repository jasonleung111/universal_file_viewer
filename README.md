UniversalFileViewer - A Flutter package to preview various file types, including images, videos, PDFs, Word, Excel, CSV, and PowerPoint files on Android and iOS.

```
Features✅ Image preview (JPG, PNG, GIF, BMP, TIFF)
✅ Video playback (MP4, AVI, MOV, MKV)
✅ PDF viewer
✅ Word documents (.doc, .docx)
✅ Excel files (.xls, .xlsx)
✅ CSV file preview
✅ PowerPoint files (.ppt, .pptx)
✅ Text files (.txt, .md)
✅ Fallback to external app if unsupported
```

##Installation

Add this package to your pubspec.yaml:
```
dependencies:
  universal_file_viewer: latest_version

```
run:
flutter pub get
```

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

##Future Enhancements<br />
✅ More file format support<br />
✅ Web support<br />
✅ Better UI customization<br />
✅ Encrypted file handling<br />


LicenseThis project is licensed under the MIT License - see the LICENSE file for details.
ContributingContributions are welcome! Feel free to submit issues and pull requests.
⭐ If you like this package, consider giving it a star on [Github](https://github.com/Shonu72/universal_file_viewer) 🚀
