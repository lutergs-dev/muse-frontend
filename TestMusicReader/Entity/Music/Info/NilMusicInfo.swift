//
//  NilMusicInfo.swift
//  MusicShare
//
//  Created by LVM_mac on 5/1/24.
//

import Foundation
import UIKit


class NilMusicInfo: MusicInfo {
    var uid: String
    var provider = MusicProvider.Else
    var artwork: UIImage? = nil
    var title = "재생 중이 아님"
    var artist: String = ""
    var album: String = ""
    
    init () {
        self.uid = ""
        self.provider = MusicProvider.Else
        self.artwork = nil
        self.title = "재생 중이 아님"
        self.artist = ""
        self.album = ""
    }
}
