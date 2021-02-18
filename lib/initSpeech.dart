import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_deepspeech/flutter_deepspeech.dart';
import 'package:path_provider/path_provider.dart';

Future<File> ensureFileInDir(String fileName, String dirPath) async {
  final file = File("$dirPath/$fileName");
  final exists = await file.exists();
  if (exists) {
    print("$fileName in dir");
    return file;
  }
  final fileBytes = await rootBundle.load("assets/$fileName");
  final buffer = fileBytes.buffer;
  await file.writeAsBytes(
      buffer.asUint8List(fileBytes.offsetInBytes, fileBytes.lengthInBytes));
  print("$fileName moved from assets folder");
  return file;
}

Future<void> initDeepSpeech() async {
  final docDir = await getApplicationDocumentsDirectory();
  final model = await ensureFileInDir("arabic.tflite", docDir.path);
  final scorer = await ensureFileInDir("arabic.scorer", docDir.path);
  await FlutterDeepSpeech.init(model.path, 4096, scorer.path);
}