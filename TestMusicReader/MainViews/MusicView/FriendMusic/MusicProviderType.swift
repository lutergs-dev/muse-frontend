//
//  MusicProviderType.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import MusicKit

enum MusicProviderType {
    case AppleMusic
    case Else
}

protocol UserMusic {
    var provider: MusicProviderType { get }
    func getMusicInfo() async -> MusicInfo
}


class UserAppleMusic: UserMusic {
    var provider: MusicProviderType = MusicProviderType.AppleMusic
    var rawSongID: String = ""
    
    static func fromSongID(rawSongID: String) -> UserAppleMusic {
        let result = UserAppleMusic()
        result.rawSongID = rawSongID
        return result
    }
    
    func getMusicInfo() async -> MusicInfo {
        if let result = await AppleMusicArtworkFinder.default.getMusicInfoBySongID(songID: MusicItemID(self.rawSongID)) {
            return result
        } else {
            return MusicInfo()
        }
    }
}
