import 'package:path/path.dart' as p;

enum FileType { image, video, pdf, word, excel, csv, ppt, text, unknown }

FileType detectFileType(String path) {
  final extension = p.extension(path).toLowerCase();

  if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff'].contains(extension)) {
    return FileType.image;
  } else if (['.mp4', '.avi', '.mov', '.mkv'].contains(extension)) {
    return FileType.video;
  } else if (extension == '.pdf') {
    return FileType.pdf;
  } else if (['.doc', '.docx'].contains(extension)) {
    return FileType.word;
  } else if (['.xls', '.xlsx'].contains(extension)) {
    return FileType.excel;
  } else if (extension == '.csv') {
    return FileType.csv;
  } else if (['.ppt', '.pptx'].contains(extension)) {
    return FileType.ppt;
  } else if (['.txt', '.md'].contains(extension)) {
    return FileType.text;
  } else {
    return FileType.unknown;
  }
}
