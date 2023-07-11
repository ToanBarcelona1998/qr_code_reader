package com.example.qr_code_reader

class QrCodeReaderResult(
    private val content: String,
    private val width: Double,
    private val height: Double,
    private val topLeft: HashMap<String, Double>,
    private val topRight: HashMap<String, Double>,
    private val bottomLeft: HashMap<String, Double>,
    private val bottomRight: HashMap<String, Double>,
){
    fun toFlutterResult() : HashMap<String,Any>{
        val map = HashMap<String,Any>()

        map["content"] = content
        map["width"] = width
        map["height"] = height
        map["topLeft"] = topLeft
        map["topRight"] = topRight
        map["bottomLeft"] = bottomLeft
        map["bottomRight"] = bottomRight

        return map
    }
}