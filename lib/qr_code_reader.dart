import 'dart:typed_data';
import 'package:qr_code_reader/src/qr_code_reader_iml.dart';
import 'package:qr_code_reader/src/types/types.dart';
export 'src/types/types.dart';

abstract class QrCodeReader {
  static final QrCodeReader _instance = QrCodeReaderIml();

  static QrCodeReader get instance => _instance;

  Future<List<QrCodeResult>> qrReaderFromNetWork({required String url}) {
    throw UnimplementedError('qrReaderFromNetWork() not implements');
  }

  Future<List<QrCodeResult>> qrReaderFromFilePath({required String filePath}) {
    throw UnimplementedError('qrReaderFromFilePath() not implements');
  }

  Future<List<QrCodeResult>> qrReaderFromFile({required Uint8List file}) {
    throw UnimplementedError('qrReaderFromFilePath() not implements');
  }
}
