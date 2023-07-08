import 'dart:developer';

final class QrCodePoint {
  final double dx;
  final double dy;

  const QrCodePoint({
    required this.dy,
    required this.dx,
  });

  factory QrCodePoint.fromNative(Map<String, dynamic> dictionary) {
    return QrCodePoint(
      dy: dictionary['y'] as double,
      dx: dictionary['x'] as double,
    );
  }
}

final class QrCodeResult {
  final String content;
  final QrCodePoint topLeft;
  final QrCodePoint topRight;
  final QrCodePoint bottomLeft;
  final QrCodePoint bottomRight;
  final double height;
  final double width;

  const QrCodeResult({
    required this.content,
    required this.width,
    required this.height,
    required this.bottomLeft,
    required this.bottomRight,
    required this.topLeft,
    required this.topRight,
  });

  factory QrCodeResult.fromNative(Map<String, dynamic> dictionary) {
    return QrCodeResult(
      content: dictionary['content'] as String,
      width: dictionary['width'] as double,
      height: dictionary['height'] as double,
      bottomLeft: QrCodePoint.fromNative(
        Map<String, dynamic>.from(
          dictionary['bottomLeft'],
        ),
      ),
      bottomRight: QrCodePoint.fromNative(
        Map<String, dynamic>.from(
          dictionary['bottomRight'],
        ),
      ),
      topLeft: QrCodePoint.fromNative(
        Map<String, dynamic>.from(dictionary['topLeft']),
      ),
      topRight: QrCodePoint.fromNative(
        Map<String, dynamic>.from(
          dictionary['topRight'],
        ),
      ),
    );
  }
}
