import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qr_code_reader_platform_interface.dart';

/// An implementation of [QrCodeReaderPlatform] that uses method channels.
class MethodChannelQrCodeReader extends QrCodeReaderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qr_code_reader');

  @override
  Future<List<Map<String, dynamic>>> scanFromFile(Uint8List file) async {
    final result = await methodChannel.invokeMethod(
      'scanFromByte',
      file,
    ) as List<dynamic>;
    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> scanFromFilePath(String filePath) async {
    final result = await methodChannel.invokeMethod(
      'scanFromFilePath',
      filePath,
    ) as List<dynamic>;

    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> scanFromNetWork(String url) async {
    final result = await methodChannel.invokeMethod(
      'scanFromNetwork',
      url,
    ) as List<dynamic>;

    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
