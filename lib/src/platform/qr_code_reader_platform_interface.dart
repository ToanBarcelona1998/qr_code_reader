import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qr_code_reader_method_channel.dart';

abstract class QrCodeReaderPlatform extends PlatformInterface {
  /// Constructs a QrCodeReaderPlatform.
  QrCodeReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static QrCodeReaderPlatform _instance = MethodChannelQrCodeReader();

  /// The default instance of [QrCodeReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelQrCodeReader].
  static QrCodeReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QrCodeReaderPlatform] when
  /// they register themselves.
  static set instance(QrCodeReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<Map<String, dynamic>>> scanFromNetWork(String url) {
    throw UnimplementedError('scanFromNetWork() not implements');
  }

  Future<List<Map<String, dynamic>>> scanFromFilePath(String filePath) {
    throw UnimplementedError('scanFromFilePath() not implements');
  }

  Future<List<Map<String, dynamic>>> scanFromFile(Uint8List file) {
    throw UnimplementedError('scanFromFile() not implements');
  }
}
