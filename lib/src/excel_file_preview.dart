import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

/// A widget that displays the contents of an Excel file specified by the file path.
///
/// The widget reads the Excel file and displays its contents in a table.
class ExcelPreviewScreen extends StatefulWidget {
  /// The path to the Excel file to display.
  final String filePath;

  /// Creates a [ExcelPreviewScreen] widget.
  const ExcelPreviewScreen({super.key, required this.filePath});

  @override
  ExcelPreviewScreenState createState() => ExcelPreviewScreenState();
}

// ignore: public_member_api_docs
class ExcelPreviewScreenState extends State<ExcelPreviewScreen> {
  /// The data read from the Excel file.
  List<List<String>> excelData = <List<String>>[];

  @override
  void initState() {
    super.initState();
    readExcelFile(widget.filePath);
  }

  @override
  void didUpdateWidget(covariant ExcelPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      readExcelFile(widget.filePath);
    }
  }

  /// Reads the Excel file at [filePath] and updates [excelData] with the data from the file.
  Future<void> readExcelFile(String filePath) async {
    try {
      File file = File(filePath);
      Uint8List fileBytes = await file.readAsBytes();
      Excel excel = Excel.decodeBytes(fileBytes);
      List<List<String>> tempData = <List<String>>[];

      for (String table in excel.tables.keys) {
        for (List<Data?> row in excel.tables[table]!.rows) {
          tempData.add(
              row.map((Data? cell) => cell?.value.toString() ?? "").toList());
        }
      }

      setState(() {
        excelData = tempData;
      });
    } catch (e) {
      debugPrint("Error reading Excel file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: excelData.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: DataTable(
                    columnSpacing: 20.0, // Adjust spacing for better visibility
                    border: TableBorder.all(),
                    columns: excelData.first
                        .map((String header) => DataColumn(label: Text(header)))
                        .toList(),
                    rows: excelData.skip(1).map((List<String> row) {
                      return DataRow(
                        cells: row
                            .map((String cell) => DataCell(SizedBox(
                                  width: 100, // Adjust cell width as needed
                                  child: Text(cell,
                                      overflow: TextOverflow.ellipsis),
                                )))
                            .toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            )
          : const Center(child: Text("Only XLSX files are supported")),
    );
  }
}
