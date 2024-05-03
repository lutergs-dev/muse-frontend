//
//  UserInfo.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

struct ResponseUserInfo: Codable {
    var name: String
    var friends: [Int]
}
