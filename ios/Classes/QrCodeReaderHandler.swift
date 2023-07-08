//
//  QrCodeReaderHandler.swift
//  qr_code_reader
//
//  Created by Nguyen Van Toan on 07/07/2023.
//

import Foundation

class QrCodeReaderHandler{
    struct QrCodeResult{
        private let content : String
        private let topLeft : Dictionary<String,Double>
        private let topRight : Dictionary<String,Double>
        private let bottomLeft : Dictionary<String,Double>
        private let bottomRight : Dictionary<String,Double>
        private let width : Double
        private let height : Double
        
        
        init(content: String, topLeft: Dictionary<String, Double>, topRight: Dictionary<String, Double>, bottomLeft: Dictionary<String, Double>, bottomRight: Dictionary<String, Double>, width: Double, height: Double) {
            self.content = content
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
            self.width = width
            self.height = height
        }
        
        public func toFlutterResult() -> Dictionary<String,Any>{
            var result : Dictionary<String,Any> = Dictionary<String,Any>()
            
            result["content"] = content
            result["topLeft"] = topLeft
            result["topRight"] = topRight
            result["bottomLeft"] = bottomLeft
            result["bottomRight"] = bottomRight
            result["width"] = width
            result["height"] = height
            
            return result
        }
    }
    
    
    private let qrCodeReaderNetworkThead : DispatchQueue
    private let qrCodeReaderFileThead : DispatchQueue
    private let qrCodeReaderFilePathThead : DispatchQueue
    
    let detector : CIDetector
    
    init() {
        qrCodeReaderNetworkThead = DispatchQueue(label: "image_reader_network")
        qrCodeReaderFileThead = DispatchQueue(label: "image_reader_file")
        qrCodeReaderFilePathThead = DispatchQueue(label: "image_reader_file_path")
        detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil , options: [
            CIDetectorAccuracy: CIDetectorAccuracyHigh])!
    }
    
    public func qrReaderFromNetWork(_ url : String , handler : @escaping (Result<[QrCodeResult],QrCodeError>) -> Void){
        
        qrCodeReaderNetworkThead.async {
            let url = URL(string: url)
                
            guard let url = url else{
                handler(.failure(.urlNotFound))
                    
                return
            }
                
            let imageData = try? Data(contentsOf: url)
                
            guard let imageData = imageData else{
                handler(.failure(.createFileFromUrlError))
                return
            }
                
            let ciImage = CIImage(data: imageData)!
                
            let features = self.detector.features(in: ciImage)
            
            var results : [QrCodeResult] = []
            
            if(features is [CIQRCodeFeature]){
                for feature in features as! [CIQRCodeFeature] {
                    
                    let bound = feature.bounds
                    
                    let topLeft : Dictionary<String,Double> = ["x" : feature.topLeft.x , "y" : feature.topLeft.y]
                    let topRight : Dictionary<String,Double> = ["x" : feature.topRight.x , "y" : feature.topRight.y]
                    let bottomLeft : Dictionary<String,Double> = ["x" : feature.bottomLeft.x , "y" : feature.bottomLeft.y]
                    let bottomRight : Dictionary<String,Double> = ["x" : feature.bottomRight.x , "y" : feature.bottomRight.y]
                    
                    let qrCodeResult = QrCodeResult(content: feature.messageString!,topLeft: topLeft,topRight: topRight,bottomLeft: bottomLeft,bottomRight: bottomRight,width: bound.width,height: bound.height)
                    
                    results.append(qrCodeResult)
                }
                
                handler(.success(results))
            }else{
                handler(.success(results))
            }
        }
    }
    
    public func qrCodeReaderFromFilePath(_ filePath : String,  handler : @escaping (Result<[QrCodeResult],QrCodeError>) -> Void){
        qrCodeReaderFilePathThead.async {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath){
                
                var url : URL? = nil
                if #available(iOS 16.0, *) {
                    url = URL(filePath: filePath)
                } else {
                   url = URL(fileURLWithPath: filePath)
                }
                    
                guard let url = url else{
                    handler(.failure(.urlNotFound))
                        
                    return
                }
                    
                let imageData = try? Data(contentsOf: url)
                
                print(imageData == nil)
                    
                guard let imageData = imageData else{
                    handler(.failure(.createFileFromUrlError))
                    return
                }
                    
                let ciImage = CIImage(data: imageData)
                
                guard let ciImage = ciImage else{
                    handler(.failure(.fileNotSupport))
                    return
                }
                    
                let features = self.detector.features(in: ciImage)
                
                var results : [QrCodeResult] = []
                
                if(features is [CIQRCodeFeature]){
                    for feature in features as! [CIQRCodeFeature] {
                        
                        let bound = feature.bounds
                        
                        let topLeft : Dictionary<String,Double> = ["x" : feature.topLeft.x , "y" : feature.topLeft.y]
                        let topRight : Dictionary<String,Double> = ["x" : feature.topRight.x , "y" : feature.topRight.y]
                        let bottomLeft : Dictionary<String,Double> = ["x" : feature.bottomLeft.x , "y" : feature.bottomLeft.y]
                        let bottomRight : Dictionary<String,Double> = ["x" : feature.bottomRight.x , "y" : feature.bottomRight.y]
                        
                        let qrCodeResult = QrCodeResult(content: feature.messageString!,topLeft: topLeft,topRight: topRight,bottomLeft: bottomLeft,bottomRight: bottomRight,width: bound.width,height: bound.height)
                        
                        results.append(qrCodeResult)
                    }
                    
                    handler(.success(results))
                }else{
                    handler(.success(results))
                }
            }else{
                handler(.failure(.fileNotExits))
            }
        }
    }
    
    public func qrCodeReaderFromByte(_ byte :  [UInt8] ,  handler : @escaping (Result<[QrCodeResult],QrCodeError>) -> Void){
        qrCodeReaderFileThead.async {
            let imageData = Data(byte)
            
            let ciImage = CIImage(data: imageData)
            
            guard let ciImage = ciImage else{
                handler(.failure(.fileNotSupport))
                return
            }
                
            let features = self.detector.features(in: ciImage)
            
            var results : [QrCodeResult] = []
            
            if(features is [CIQRCodeFeature]){
                for feature in features as! [CIQRCodeFeature] {
                    
                    let bound = feature.bounds
                    
                    let topLeft : Dictionary<String,Double> = ["x" : feature.topLeft.x , "y" : feature.topLeft.y]
                    let topRight : Dictionary<String,Double> = ["x" : feature.topRight.x , "y" : feature.topRight.y]
                    let bottomLeft : Dictionary<String,Double> = ["x" : feature.bottomLeft.x , "y" : feature.bottomLeft.y]
                    let bottomRight : Dictionary<String,Double> = ["x" : feature.bottomRight.x , "y" : feature.bottomRight.y]
                    
                    let qrCodeResult = QrCodeResult(content: feature.messageString!,topLeft: topLeft,topRight: topRight,bottomLeft: bottomLeft,bottomRight: bottomRight,width: bound.width,height: bound.height)
                    
                    results.append(qrCodeResult)
                }
                
                handler(.success(results))
            }else{
                handler(.success(results))
            }
        }
    }
}
