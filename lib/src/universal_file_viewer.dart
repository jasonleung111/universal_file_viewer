// ignore_for_file: always_specify_types, public_member_api_docs

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_file_viewer/src/csv_file_preview.dart';
import 'package:universal_file_viewer/src/excel_file_preview.dart';
import 'package:universal_file_viewer/src/word_file_preview.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

class UniversalFileViewer extends StatelessWidget {
  final String filePath;

  const UniversalFileViewer({super.key, required this.filePath});

  @override

  /// Builds a widget that displays the file at [filePath].
  ///
  /// The widget depends on the type of the file. If the file is an image, video,
  /// or PDF, a widget is returned that displays the file directly. Otherwise, a
  /// button is returned that opens the file in an external application when
  /// pressed.
  Widget build(BuildContext context) {
    final fileType = detectFileType(filePath);

    switch (fileType) {
      case FileType.image:
        return Center(child: Image.file(File(filePath)));
      case FileType.video:
        return VideoPlayerWidget(filePath: filePath);
      case FileType.pdf:
        return SfPdfViewer.file(File(filePath));
      case FileType.word:
        return WordViewer(filePath: filePath);
      case FileType.excel:
        return ExcelPreviewScreen(filePath: filePath);
      case FileType.csv:
        return CsvPreviewScreen(filePath: filePath);
      // case FileType.ppt:
      //   return OfficeFileViewer(filePath: filePath);
      default:
        return Center(
          child: ElevatedButton(
            onPressed: () => OpenFile.open(filePath),
            child: const Text('Open in external app'),
          ),
        );
    }
  }
}
