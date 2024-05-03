//
//  HttpException.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

enum HttpException: Error {
    case InvalidUrlException(String)
    case JsonParseException(String)
    case InvalidResponse(String)
}
