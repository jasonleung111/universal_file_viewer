import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'File Viewer Test', home: FileViewerScreen());
  }
}

class FileViewerScreen extends StatefulWidget {
  const FileViewerScreen({super.key});

  @override
  FileViewerScreenState createState() => FileViewerScreenState();
}

class FileViewerScreenState extends State<FileViewerScreen> {
  String? _filePath;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universal File Viewer Test')),
      body: Column(
        children: [
          ElevatedButton(onPressed: _pickFile, child: const Text('Pick a File')),
          const SizedBox(height: 20),
          Expanded(
            key: ValueKey(_filePath),
            child:
                _filePath == null
                    ? const Center(child: Text('No file selected'))
                    : UniversalFileViewer(file: File.fromUri(Uri.parse(_filePath!))),
          ),
        ],
      ),
    );
  }
}
