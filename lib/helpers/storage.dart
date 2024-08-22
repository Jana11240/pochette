import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<void> writeToFile(String fileName, String content) async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$fileName.txt');
    await file.writeAsString(content);
  }

  Future<String> readFromFile(String fileName) async {
    try {
      final directory = await getApplicationSupportDirectory();
      final file = File('${directory.path}/$fileName.txt');
      return await file.readAsString();
    } catch (e) {
      return 'Error: $e';
    }
  }

}