package com.example.qr_code_reader

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** QrCodeReaderPlugin */
class QrCodeReaderPlugin: FlutterPlugin , ActivityAware {
  private lateinit var flutterPluginBinding : FlutterPlugin.FlutterPluginBinding
  private lateinit var activityBinding : ActivityPluginBinding

  private var qrCodeHandler : QrCodeReaderHandler? =null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    qrCodeHandler?.stop()

    qrCodeHandler = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding

    start()
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    qrCodeHandler?.stop()
    qrCodeHandler = null
  }

  private fun start(){
    qrCodeHandler = QrCodeReaderHandler(activityBinding.activity,flutterPluginBinding)
  }

}
