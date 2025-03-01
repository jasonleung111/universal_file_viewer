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
  ///
  /// This list contains the data from the Excel file, where each row is a
  /// list of strings. The first row is the header, so the first element of
  /// each row is the column name.
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

  /// Reads the Excel file at [filePath] and updates [excelData] with the
  /// data from the file.
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

  /// Builds a [DataTable] widget to display the data from the Excel file.
  ///
  /// If the Excel file is empty, a [Center] widget with a [Text] widget
  /// displaying the message "No Data Loaded" is returned.
  ///
  /// Otherwise, a [SingleChildScrollView] widget is returned with its
  /// scroll direction set to [Axis.horizontal] so that the user can scroll
  /// horizontally to view all the columns in the table. The table is
  /// constructed from the data loaded from the Excel file. The first row is
  /// used as the header, and each subsequent row is a data row. The columns
  /// are also determined by the data in the first row.

  Widget build(BuildContext context) {
    return Scaffold(
      body: excelData.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: excelData.first
                    .map((String header) => DataColumn(label: Text(header)))
                    .toList(),
                rows: excelData.skip(1).map((List<String> row) {
                  return DataRow(
                    cells:
                        row.map((String cell) => DataCell(Text(cell))).toList(),
                  );
                }).toList(),
              ),
            )
          : const Center(child: Text("Only XLXS files are supported")),
    );
  }
}
