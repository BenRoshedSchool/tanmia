import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ConstantMobile {
  static Future<void> exportToExcelMobile(List<int> excelBytes, String filename) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/$filename');
    await file.writeAsBytes(excelBytes);
    print("File saved to ${file.path}");
  }
}
