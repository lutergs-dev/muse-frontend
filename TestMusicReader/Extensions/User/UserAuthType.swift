//
//  UserAuthType.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

@objc enum UserAuthType: Int {
    case Apple = 0
    case Google = 1
    
    var stringValue: String {
        switch self {
        case .Apple:
            return "Apple"
        case .Google:
            return "Google"
        }
    }
}
