//
//  AppleMusicInfo.swift
//  MusicShare
//
//  Created by LVM_mac on 5/1/24.
//

import Foundation
import MediaPlayer
import MusicKit
import UIKit

struct AppleMusicInfo: MusicInfo {
    var provider = MusicProvider.AppleMusic
    var artwork: UIImage? = nil
    var title: String = "재생 중이 아님"
    var artist: String = ""
    var album: String = ""

    static func fromMPMediaItem(item: MPMediaItem) -> AppleMusicInfo {
        let artworkImage = item.artwork.map { artwork in
            return artwork.image(at: CGSize(width: artwork.bounds.width, height: artwork.bounds.height))
        }
        return AppleMusicInfo(
            artwork: artworkImage ?? nil,
            title: item.title ?? "재생 중이 아님",
            artist: item.artist ?? "",
            album: item.albumTitle ?? ""
        )
    }

    static func fromSong(song: Song, image: UIImage) -> AppleMusicInfo {
        return AppleMusicInfo(
            artwork: image,
            title: song.title,
            artist: song.artistName,
            album: song.albumTitle ?? ""
        )
    }
    
    static func fromSongID(id: String) -> AppleMusicInfo {
        if let result = 
    }

    mutating func setArtwork(image: UIImage) {
        self.artwork = image
    }
}

