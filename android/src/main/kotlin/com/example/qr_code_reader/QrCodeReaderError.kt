package com.example.qr_code_reader

enum class QrCodeReaderError(val flutterErrorCode : String) {
    URLNotFound("0"),
    CreateFileFromUrlError("1"),
    FileNotExits("3"),
    FileNotSupport("4"),
    Other("10"),
}