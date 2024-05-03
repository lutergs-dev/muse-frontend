//
//  MusicFinder.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import MediaPlayer
import MusicKit

class AppleMusicArtworkFinder {
    
    static let `default` = AppleMusicArtworkFinder()
    
    func getMusicArtwork(item: MPMediaItem) async -> UIImage? {
        if let data = await self.findFirstMusicBySongID(songID: MusicItemID(item.playbackStoreID)) {
            return await self.getArtworkImage(song: data)
        } else {
            return nil
        }
    }
    
    func getMusicInfoBySongID(songID: MusicItemID) async -> MusicInfo? {
        if let song = await self.findFirstMusicBySongID(songID: songID) {
            if let image = await self.getArtworkImage(song: song) {
                return AppleMusicInfo.fromSong(song: song, image: image)
            }
        }
        return nil
    }
    
    func getMusicArtwork(songID: MusicItemID) async -> UIImage? {
        if let data = await self.findFirstMusicBySongID(songID: songID) {
            return await self.getArtworkImage(song: data)
        } else {
            return nil
        }
    }
    
    private func findFirstMusicBySongID(songID: MusicItemID) async -> Song? {
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: songID)
        do {
            let response = try await request.response()
            return response.items.first
        } catch {
            print("An error occured! \(error)")
            return nil
        }
    }
    
    private func getArtworkImage(song: Song) async -> UIImage? {
        if let artworkURL = song.artwork?.url(width: 300, height: 300) {
            if let (data, _) = try? await URLSession.shared.data(from: artworkURL) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
