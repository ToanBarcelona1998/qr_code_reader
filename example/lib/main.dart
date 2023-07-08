import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_reader/qr_code_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async{
                  try {
                    final results = await QrCodeReader.instance.qrReaderFromNetWork(
                      url: 'https://purrfect-ai-use.s3.us-east-1.amazonaws.com/purrfect-ai-delivery/26901d34-30f6-4ee6-95f6-3f938c4a6617_b78145693084453ca94829a2e7ce0dd7.png',
                    );

                    if(results.isEmpty){
                      log('Qr Code Not found');
                    }

                    for(final result in results){
                      log(result.content);
                    }

                  } catch (e) {
                    if (e is QrCodeReaderError) {
                      log(e.toString());
                    }
                    log('error ${e.toString()}');
                  }
                },
                child: const Text('Scan From Network'),
              ),
              ElevatedButton(
                onPressed: () async{
                  try {
                    final HttpClient httpClient = HttpClient();
                    var request = await httpClient.getUrl(Uri.parse('https://www.techopedia.com/wp-content/uploads/2023/03/aee977ce-f946-4451-8b9e-bba278ba5f13.png'));
                    var response = await request.close();
                    final bytes = await consolidateHttpClientResponseBytes(response);

                    final results = await QrCodeReader.instance.qrReaderFromFile(
                      file: bytes,
                    );

                    if(results.isEmpty){
                      log('Qr Code Not found');
                    }

                    for(final result in results){
                      log(result.content);
                    }

                  } catch (e) {
                    if (e is QrCodeReaderError) {
                      log(e.toString());
                    }
                    log('error ${e.toString()}');
                  }
                },
                child: const Text('Scan From File'),
              ),
              ElevatedButton(
                onPressed: () async{
                  try {
                    final HttpClient httpClient = HttpClient();
                    var request = await httpClient.getUrl(Uri.parse('https://purrfect-ai-use.s3.us-east-1.amazonaws.com/purrfect-ai-delivery/26901d34-30f6-4ee6-95f6-3f938c4a6617_b78145693084453ca94829a2e7ce0dd7.png'));
                    var response = await request.close();
                    final bytes = await consolidateHttpClientResponseBytes(response);

                    String dir = (await getApplicationDocumentsDirectory()).path;
                    File file = File('$dir/qr_file.png');

                    await file.writeAsBytes(bytes);

                    final results = await QrCodeReader.instance.qrReaderFromFilePath(
                      filePath: file.path
                    );

                    if(results.isEmpty){
                      log('Qr Code Not found');
                    }

                    for(final result in results){
                      log(result.content);
                    }

                  } catch (e) {
                    if (e is QrCodeReaderError) {
                      log(e.toString());
                    }
                  }
                },
                child: const Text('Scan From File Path'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
