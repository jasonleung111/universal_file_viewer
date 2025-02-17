import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_file_viewer/src/video_player_preview.dart';

import 'file_type_detector.dart';

class UniversalFileViewer extends StatelessWidget {
  final String filePath;

  const UniversalFileViewer({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final fileType = detectFileType(filePath);

    switch (fileType) {
      case FileType.image:
        return Image.file(File(filePath));
      case FileType.video:
        return VideoPlayerWidget(filePath: filePath);
      case FileType.pdf:
        return SfPdfViewer.file(File(filePath));
      // case FileType.word:
      // case FileType.excel:
      // case FileType.csv:
      // case FileType.ppt:
      //   return OfficeFileViewer(filePath: filePath);
      default:
        return Center(
          child: ElevatedButton(
            onPressed: () => OpenFilex.open(filePath),
            child: const Text('Open in external app'),
          ),
        );
    }
  }
}
