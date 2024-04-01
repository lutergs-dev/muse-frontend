//
//  MusicInfo.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import MediaPlayer
import MusicKit
import UIKit

struct MusicInfo {
    var artwork: UIImage? = nil
    var title: String = "재생 중이 아님"
    var artist: String = ""
    var album: String = ""

    static func fromMPMediaItem(item: MPMediaItem) -> MusicInfo {
        let artworkImage = item.artwork.map { artwork in
            return artwork.image(at: CGSize(width: artwork.bounds.width, height: artwork.bounds.height))
        }
        return MusicInfo(
            artwork: artworkImage ?? nil,
            title: item.title ?? "재생 중이 아님",
            artist: item.artist ?? "",
            album: item.albumTitle ?? ""
        )
    }

    static func fromSong(song: Song, image: UIImage) -> MusicInfo {
        return MusicInfo(
            artwork: image,
            title: song.title,
            artist: song.artistName,
            album: song.albumTitle ?? ""
        )
    }

    mutating func setArtwork(image: UIImage) {
        self.artwork = image
    }
}
