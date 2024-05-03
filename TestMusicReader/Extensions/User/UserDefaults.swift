//
//  UserDefaults.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

extension UserDefaults {
    @objc dynamic var userId: Int {
        get { integer(forKey: "userId") }
        set { set(newValue, forKey: "userId") }
    }

    @objc dynamic var userName: String? {
        get { string(forKey: "userName") }
        set { set(newValue, forKey: "userName") }
    }
}
