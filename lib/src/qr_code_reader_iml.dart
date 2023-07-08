import 'package:flutter/services.dart';
import 'package:qr_code_reader/qr_code_reader.dart';
import 'package:qr_code_reader/src/platform/qr_code_reader_platform_interface.dart';

final class QrCodeReaderIml implements QrCodeReader {
  QrCodeReaderIml();

  final QrCodeReaderPlatform _platform = QrCodeReaderPlatform.instance;

  @override
  Future<List<QrCodeResult>> qrReaderFromFile({required Uint8List file}) async {
    try {
      List<QrCodeResult> qrCodeResults = List.empty(growable: true);

      final results = await _platform.scanFromFile(file);

      for (final result in results) {
        QrCodeResult qrCodeResult = QrCodeResult.fromNative(result);

        qrCodeResults.add(qrCodeResult);
      }

      return qrCodeResults;
    } on PlatformException catch (e) {
      QrCodeReaderError error = e.qrCodeError;

      throw error;
    }
  }

  @override
  Future<List<QrCodeResult>> qrReaderFromFilePath(
      {required String filePath}) async {
    try {
      List<QrCodeResult> qrCodeResults = List.empty(growable: true);

      final results = await _platform.scanFromFilePath(filePath);

      for (final result in results) {
        QrCodeResult qrCodeResult = QrCodeResult.fromNative(result);

        qrCodeResults.add(qrCodeResult);
      }

      return qrCodeResults;
    } on PlatformException catch (e) {
      QrCodeReaderError error = e.qrCodeError;

      throw error;
    }
  }

  @override
  Future<List<QrCodeResult>> qrReaderFromNetWork({required String url}) async {
    try {
      List<QrCodeResult> qrCodeResults = List.empty(growable: true);

      final results = await _platform.scanFromNetWork(url);

      for (final result in results) {
        QrCodeResult qrCodeResult = QrCodeResult.fromNative(result);

        qrCodeResults.add(qrCodeResult);
      }

      return qrCodeResults;
    } on PlatformException catch (e) {
      QrCodeReaderError error = e.qrCodeError;

      throw error;
    }
  }
}
