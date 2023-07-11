package com.example.qr_code_reader

import android.app.Activity
import android.graphics.BitmapFactory
import android.util.Log
import android.webkit.URLUtil
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.vision.barcode.BarcodeScanner
import com.google.mlkit.vision.barcode.BarcodeScannerOptions
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.barcode.common.Barcode
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import okhttp3.*
import java.io.File
import java.io.IOException
import kotlin.collections.HashMap


public final class QrCodeReaderHandler constructor(
    activity: Activity,
    flutterPluginBinding: FlutterPluginBinding
) : MethodCallHandler {
    private var barCodeDetector: BarcodeScanner

    private var channel: MethodChannel

    init {
        val options = BarcodeScannerOptions.Builder()
            .setBarcodeFormats(Barcode.FORMAT_QR_CODE, Barcode.FORMAT_ALL_FORMATS)
            .enableAllPotentialBarcodes().build()

        barCodeDetector = BarcodeScanning.getClient(options)

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "qr_code_reader")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "scanFromNetwork" -> {
                val url: String = if (call.arguments is String) {
                    call.arguments as String
                } else {
                    result.error("-1", null, null)
                    return
                }

                processFromNetwork(url) { results, error ->
                    if (error != null) {
                        result.error(error.flutterErrorCode, null, null)
                    } else {
                        val flutterResults = results?.map { e -> e.toFlutterResult() }
                            ?: listOf<HashMap<String, Any>>()
                        result.success(flutterResults)
                    }
                }
            }
            "scanFromByte" -> {
                val bytes: ByteArray = if (call.arguments is ByteArray) {
                    call.arguments as ByteArray
                } else {
                    result.error("-1", null, null)
                    return
                }

                processFromFile(bytes) { results, error ->
                    if (error != null) {
                        result.error(error.flutterErrorCode, null, null)
                    } else {
                        val flutterResults = results?.map { e -> e.toFlutterResult() }
                            ?: listOf<HashMap<String, Any>>()
                        result.success(flutterResults)
                    }
                }
            }
            "scanFromFilePath" -> {
                val filePath: String = if (call.arguments is String) {
                    call.arguments as String
                } else {
                    result.error("-1", null, null)
                    return
                }

                processFromFilePath(filePath) { results, error ->
                    if (error != null) {
                        result.error(error.flutterErrorCode, null, null)
                    } else {
                        val flutterResults = results?.map { e -> e.toFlutterResult() }
                            ?: listOf<HashMap<String, Any>>()
                        result.success(flutterResults)
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun processFromFilePath(
        filePath: String,
        callBack: (results: List<QrCodeReaderResult>?, error: QrCodeReaderError?) -> Unit
    ) {
        val handlerThread = object : Thread() {
            override fun run() {
                val index = filePath.lastIndexOf(".")

                if (index == -1 || index == filePath.length - 1) {
                    callBack(null, QrCodeReaderError.FileNotSupport)
                    return;
                }

                val fileType = filePath.substring(index + 1, filePath.length)

                if (!listOf("JPEG", "PNG", "JPG", "GIF").contains(fileType.uppercase())) {
                    callBack(null, QrCodeReaderError.FileNotSupport)
                    return;
                }


                val file = File(filePath)

                if (file.exists()) {
                    val options = BitmapFactory.Options()

                    options.inMutable = true

                    val bitmap = BitmapFactory.decodeFile(file.absolutePath, options)

                    Log.w("QR_CODE_READER","${bitmap.width} - ${bitmap.height}")

                    try {
                        val barcodes = Tasks.await(barCodeDetector.process(bitmap, 0))

                        val size = barcodes.size

                        if (size == 0) {
                            callBack(listOf(), null)
                        } else {
                            val qrCodeResults = mutableListOf<QrCodeReaderResult>()
                            for (i in 0 until size) {

                                val barCode = barcodes[i]
                                val box = barCode.boundingBox!!

                                val topLeft = HashMap<String, Double>()

                                topLeft["x"] = (box.width() - box.left).toDouble()
                                topLeft["y"] = box.top.toDouble()

                                val topRight = HashMap<String, Double>()

                                topRight["x"] = (box.width() - box.right).toDouble()
                                topRight["y"] = box.top.toDouble()

                                val bottomLeft = HashMap<String, Double>()

                                bottomLeft["x"] = (box.width() - box.left).toDouble()
                                bottomLeft["y"] = box.bottom.toDouble()

                                val bottomRight = HashMap<String, Double>()

                                bottomRight["x"] = (box.width() - box.right).toDouble()
                                bottomRight["y"] = box.bottom.toDouble()

                                val qrCodeResult = QrCodeReaderResult(
                                    barCode.rawValue!!,
                                    bitmap.width.toDouble(),
                                    bitmap.height.toDouble(),
                                    topLeft,
                                    topRight,
                                    bottomLeft,
                                    bottomRight,
                                )

                                qrCodeResults.add(qrCodeResult)
                            }
                            callBack(qrCodeResults, null)

                        }
                    } catch (e: Exception) {
                        Log.e("QR_CODE_READER", "Error ${e.message}\n${e.localizedMessage}")
                        callBack(null, QrCodeReaderError.Other)
                    }
                } else {
                    callBack(null, QrCodeReaderError.FileNotExits)
                }

                super.run()
            }
        }

        handlerThread.start()
    }

    private fun processFromFile(
        bytes: ByteArray,
        callBack: (results: List<QrCodeReaderResult>?, error: QrCodeReaderError?) -> Unit
    ) {
        val handlerThread = object : Thread() {
            override fun run() {
                val options = BitmapFactory.Options()

                options.inMutable = true

                val bitmap =
                    BitmapFactory.decodeByteArray(bytes, 0, bytes.size, options)

                Log.w("QR_CODE_READER","${bitmap.width} - ${bitmap.height}")
                try {
                    val barcodes = Tasks.await(barCodeDetector.process(bitmap,0))
                    val size = barcodes.size

                    if (size == 0) {
                        callBack(listOf(), null)
                    } else {
                        val qrCodeResults = mutableListOf<QrCodeReaderResult>()
                        for (i in 0 until size) {

                            val barCode = barcodes[i]

                            Log.w("QR_CODE_READER",barCode.rawValue.toString())
                            Log.w("QR_CODE_READER",barCode.displayValue.toString())

                            val box = barCode.boundingBox!!

                            val topLeft = HashMap<String, Double>()

                            topLeft["x"] = (box.width() - box.left).toDouble()
                            topLeft["y"] = box.top.toDouble()

                            val topRight = HashMap<String, Double>()

                            topRight["x"] = (box.width() - box.right).toDouble()
                            topRight["y"] = box.top.toDouble()

                            val bottomLeft = HashMap<String, Double>()

                            bottomLeft["x"] = (box.width() - box.left).toDouble()
                            bottomLeft["y"] = box.bottom.toDouble()

                            val bottomRight = HashMap<String, Double>()

                            bottomRight["x"] = (box.width() - box.right).toDouble()
                            bottomRight["y"] = box.bottom.toDouble()

                            val qrCodeResult = QrCodeReaderResult(
                                barCode.rawValue!!,
                                bitmap.width.toDouble(),
                                bitmap.height.toDouble(),
                                topLeft,
                                topRight,
                                bottomLeft,
                                bottomRight,
                            )

                            qrCodeResults.add(qrCodeResult)
                        }
                        callBack(qrCodeResults, null)

                    }
                } catch (e: Exception) {
                    Log.e("QR_CODE_READER", "Error ${e.message}\n${e.localizedMessage}")
                    callBack(null, QrCodeReaderError.Other)
                }
                super.run()
            }
        }

        handlerThread.start()
    }

    private fun processFromNetwork(
        url: String,
        callBack: (results: List<QrCodeReaderResult>?, error: QrCodeReaderError?) -> Unit
    ) {

        val handlerThread = object : Thread() {
            override fun run() {
                if (!URLUtil.isValidUrl(url)) {
                    callBack(null, QrCodeReaderError.URLNotFound)
                    return
                }

                val request = Request.Builder().url(url).build()

                OkHttpClient().newCall(request).enqueue(object : Callback {
                    override fun onFailure(call: Call, e: IOException) {
                        callBack(null, QrCodeReaderError.CreateFileFromUrlError)
                    }

                    override fun onResponse(call: Call, response: Response) {
                        val body = response.body()

                        if (body != null) {
                            val bytes = body.bytes()

                            val options = BitmapFactory.Options()

                            options.inMutable = true

                            val bitmap =
                                BitmapFactory.decodeByteArray(bytes, 0, bytes.size, options)

                            Log.w("QR_CODE_READER","${bitmap.width} - ${bitmap.height}")

                            try {
                                val barcodes = Tasks.await(barCodeDetector.process(bitmap, 0))

                                val size = barcodes.size


                                if (size == 0) {
                                    callBack(listOf(), null)
                                } else {
                                    val qrCodeResults = mutableListOf<QrCodeReaderResult>()
                                    for (i in 0 until size) {
                                        val barCode = barcodes[i]
                                        val box = barCode.boundingBox!!

                                        val topLeft = HashMap<String, Double>()

                                        topLeft["x"] = (box.width() - box.left).toDouble()
                                        topLeft["y"] = box.top.toDouble()

                                        val topRight = HashMap<String, Double>()

                                        topRight["x"] = (box.width() - box.right).toDouble()
                                        topRight["y"] = box.top.toDouble()

                                        val bottomLeft = HashMap<String, Double>()

                                        bottomLeft["x"] = (box.width() - box.left).toDouble()
                                        bottomLeft["y"] = box.bottom.toDouble()

                                        val bottomRight = HashMap<String, Double>()

                                        bottomRight["x"] = (box.width() - box.right).toDouble()
                                        bottomRight["y"] = box.bottom.toDouble()

                                        val qrCodeResult = QrCodeReaderResult(
                                            barCode.rawValue!!,
                                            bitmap.width.toDouble(),
                                            bitmap.height.toDouble(),
                                            topLeft,
                                            topRight,
                                            bottomLeft,
                                            bottomRight,
                                        )

                                        qrCodeResults.add(qrCodeResult)
                                    }
                                    callBack(qrCodeResults, null)

                                }
                            } catch (e: Exception) {
                                Log.e("QR_CODE_READER", "Error ${e.message}\n${e.localizedMessage}")
                                callBack(null, QrCodeReaderError.Other)
                            }

                        } else {
                            callBack(null, QrCodeReaderError.CreateFileFromUrlError)
                        }
                    }

                })
                super.run()
            }
        }

        handlerThread.start()
    }


    public fun stop() {
        channel.setMethodCallHandler(null)
    }

}