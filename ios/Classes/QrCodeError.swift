//
//  QrCodeError.swift
//  qr_code_reader
//
//  Created by Nguyen Van Toan on 07/07/2023.
//

import Foundation

enum QrCodeError : Error{
    case urlNotFound
    case createFileFromUrlError
    case createFileFromPathError
    case fileNotSupport
    case fileNotExits
}

extension QrCodeError{
    func getFlutterErrorCode() -> String{
        switch(self){
        case .urlNotFound:
            return "0"
        case .createFileFromUrlError:
            return "1"
        case .createFileFromPathError:
            return "2"
        case .fileNotExits:
            return "3"
        case .fileNotSupport:
            return "4"
        }
    }
}
