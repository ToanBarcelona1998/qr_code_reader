import Flutter
import UIKit

public class QrCodeReaderPlugin: NSObject, FlutterPlugin {
    private var handler : QrCodeReaderHandler? = QrCodeReaderHandler()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "qr_code_reader", binaryMessenger: registrar.messenger())
    let instance = QrCodeReaderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(handler == nil){
        handler = QrCodeReaderHandler()
    }
    switch call.method {
    case "scanFromNetwork":
        guard let url = call.arguments as? String else{
            result(FlutterError(code: "-1", message: nil, details: nil))
            return
        }
        
        handler?.qrReaderFromNetWork(url , handler: {handlerResult in
            switch(handlerResult){
            case .success(let qrCodeResults):
                let results = qrCodeResults.map {rs in rs.toFlutterResult()}
                
                result(results)
                
                break;
            case .failure(let error):
                result(FlutterError(code: error.getFlutterErrorCode(), message: nil, details: nil))
                break;
            }
        })
    case "scanFromFilePath":
        guard let path = call.arguments as? String else{
            result(FlutterError(code: "-1", message: nil, details: nil))
            return
        }
        
        handler?.qrCodeReaderFromFilePath(path, handler: {handlerResult in
            switch(handlerResult){
            case .success(let qrCodeResults):
                let results = qrCodeResults.map {rs in rs.toFlutterResult()}
                
                result(results)
                
                break;
            case .failure(let error):
                result(FlutterError(code: error.getFlutterErrorCode(), message: nil, details: nil))
                break;
            }
        })
    case "scanFromByte":
        guard let arrayInt = call.arguments as? FlutterStandardTypedData else{
            result(FlutterError(code: "-1", message: nil, details: nil))
            return
        }
        
        let byte = [UInt8](arrayInt.data)
        
        handler?.qrCodeReaderFromByte(byte, handler: {handlerResult in
            switch(handlerResult){
            case .success(let qrCodeResults):
                let results = qrCodeResults.map {rs in rs.toFlutterResult()}
                
                result(results)
                
                break;
            case .failure(let error):
                result(FlutterError(code: error.getFlutterErrorCode(), message: nil, details: nil))
                break;
            }
        })
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    
    
    deinit{
        handler = nil
    }
}
