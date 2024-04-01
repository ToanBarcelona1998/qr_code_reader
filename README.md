# qr_code_reader

A Flutter library to scan qr code using mlkit scanner for android and CIDetector for IOS.

## Features
- Scan from File
- Scan from remote url
- Scan from file path

## Usage

```dart

final QrCodeReader qrCodeReader = QrCodeReader.instance;

void scanFromUrl() async {
  try {
    final results =
    await QrCodeReader.instance.qrReaderFromNetWork(
      url:
      'https://purrfect-ai-use.s3.us-east-1.amazonaws.com/purrfect-ai-delivery/26901d34-30f6-4ee6-95f6-3f938c4a6617_b78145693084453ca94829a2e7ce0dd7.png',
    );

    if (results.isEmpty) {
      log('Qr Code Not found');
    }

    for (final result in results) {
      log(result.content);
    }
  } catch (e) {
    if (e is QrCodeReaderError) {
      log(e.toString());
    }
    log('error ${e.toString()}');
  }
}

void scanFromFilePath() async {
  try {
    final HttpClient httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(
        'https://purrfect-ai-use.s3.us-east-1.amazonaws.com/purrfect-ai-delivery/26901d34-30f6-4ee6-95f6-3f938c4a6617_b78145693084453ca94829a2e7ce0dd7.png'));
    var response = await request.close();
    final bytes =
    await consolidateHttpClientResponseBytes(response);

    String dir =
        (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/qr_file.png');

    await file.writeAsBytes(bytes);

    final results = await QrCodeReader.instance
        .qrReaderFromFilePath(filePath: file.path);

    if (results.isEmpty) {
      log('Qr Code Not found');
    }

    for (final result in results) {
      log(result.content);
    }
  } catch (e) {
    if (e is QrCodeReaderError) {
      log(e.toString());
    }
  }
}

void scanFromFile() async {
  try {
    final HttpClient httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(
        'https://www.techopedia.com/wp-content/uploads/2023/03/aee977ce-f946-4451-8b9e-bba278ba5f13.png'));
    var response = await request.close();
    final bytes =
    await consolidateHttpClientResponseBytes(response);

    final results =
    await QrCodeReader.instance.qrReaderFromFile(
      file: bytes,
    );

    if (results.isEmpty) {
      log('Qr Code Not found');
    }

    for (final result in results) {
      log(result.content);
    }
  } catch (e) {
    if (e is QrCodeReaderError) {
      log(e.toString());
    }
    log('error ${e.toString()}');
  }
}
```

