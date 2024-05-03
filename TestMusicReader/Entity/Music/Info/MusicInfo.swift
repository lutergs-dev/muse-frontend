//
//  MusicInfo.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//


import Foundation
import UIKit

protocol MusicInfo {
    var provider: MusicProvider { get set }
    var artwork: UIImage? { get set }
    var title: String { get set }
    var artist: String { get set }
    var album: String { get set }
}

class NilMusicInfo: MusicInfo {
    var provider = MusicProvider.Else
    var artwork: UIImage? = nil
    var title = "재생 중이 아님"
    var artist: String = ""
    var album: String = ""
}

