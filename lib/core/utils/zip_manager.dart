import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

class ZipManager {
  static Future<File?> saveZip(http.Response resp) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/downloaded.zip';
    final file = File(filePath);
    return file.writeAsBytes(resp.bodyBytes);
  }

  static Future<void> extractZipFile(File zipFile) async {
    try {
      // Get the application's document directory to extract the files
      final directory = await getApplicationDocumentsDirectory();
      final extractionPath = directory.path;
      log('Extraction path: $extractionPath');

      // Ensure the extraction directory exists
      await Directory(extractionPath).create(recursive: true);

      // Decode the ZIP file with password
      Archive archive = ZipDecoder().decodeBytes(
        zipFile.readAsBytesSync(),
        verify: true,
        password: 'Digital Fusion 2018',
      );

      log('Archive contains ${archive.length} files:');
      for (final file in archive) {
        log('File: ${file.name}, Size: ${file.size}');

        final filename = '$extractionPath/${file.name}';
        if (file.isFile) {
          final outFile = File(filename);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
          // await _loadCfData(outFile);
          log('File created: ${outFile.path}');
        } else {
          // If it's a directory, ensure it exists
          await Directory(filename).create(recursive: true);
          log('Directory created: $filename');
        }
      }

      log('ZIP file extracted successfully to $extractionPath');
    } catch (e, stacktrace) {
      log('Error during extraction: $e');
      log('Stacktrace: $stacktrace');
    }
  }

  static Future<dynamic> loadData(String fileName, Function fromJson) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = directory.path;
      final finalFileName = '$filePath/$fileName';
      final file = File(finalFileName);
      // Read the file
      String jsonData = await file.readAsString();
      // Decode the JSON
      List<dynamic> parsedJson = jsonDecode(jsonData);
      // log(parsedJson.toString());
      // Assuming each item in the list is a map and filtering by selectedDateFilter
      var datas = parsedJson.map((data) => fromJson(data)).toList();
      return datas;
    } catch (e) {
      log('Error parsing JSON data: $e');
    }
  }
}
