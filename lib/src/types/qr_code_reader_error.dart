import 'package:flutter/services.dart';

extension PlatformExceptionMapper on PlatformException {
  QrCodeReaderError get qrCodeError {
    switch (code) {
      case '-1':
        return QrCodeReaderError.argumentNotFound;
      case '0':
        return QrCodeReaderError.urlNotFound;
      case '1':
        return QrCodeReaderError.createFileFromUrlError;
      case '2':
        return QrCodeReaderError.createFileFromPathError;
      case '3':
        return QrCodeReaderError.fileNotExits;
      case '4':
        return QrCodeReaderError.fileNotSupport;
      default:
        return QrCodeReaderError.other;
    }
  }
}

enum QrCodeReaderError {
  argumentNotFound,
  urlNotFound,
  createFileFromUrlError,
  createFileFromPathError,
  fileNotSupport,
  fileNotExits,
  other,
}
