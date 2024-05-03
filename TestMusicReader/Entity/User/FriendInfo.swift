//
//  FriendInfo.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation
import MediaPlayer
import MusicKit


class DummyUserMusicData: ObservableObject {
    var friends: [User] = []
    
    init () {
        Task {
            await self.fill()
        }
    }
    
    private func fill() async {
        friends.append(
            User(id: 1,
                 name: "test user 1",
                 music: await AppleMusicArtworkFinder.default.getMusicInfoBySongID(songID: MusicItemID("1613139922"))
                 ?? NilMusicInfo(),
                 playStatus: MusicPlayStatus.Playing
            )  // TOMBOY - (여자) 아이들)
        )
        friends.append(
            User(id: 2,
                 name: "test user 2",
                 music: await AppleMusicArtworkFinder.default.getMusicInfoBySongID(songID: MusicItemID("1621089608"))
                 ?? NilMusicInfo(),
                 playStatus: MusicPlayStatus.Paused
            )  // FEARLESS - 르세라핌
        )
        friends.append(
            User(id: 3,
                 name: "test user 3",
                 music: await AppleMusicArtworkFinder.default.getMusicInfoBySongID(songID: MusicItemID("1519364407"))
                 ?? NilMusicInfo(),
                 playStatus: MusicPlayStatus.Paused
            )  // How You Like That - BLACKPINK
        )
        friends.append(
            User(id: 4,
                 name: "test user 4",
                 music: NilMusicInfo(),
                 playStatus: MusicPlayStatus.Stopped
            )  // TOMBOY - (여자) 아이들)
        )
        friends.append(
            User(id: 5,
                 name: "test user 5",
                 music: await AppleMusicArtworkFinder.default.getMusicInfoBySongID(songID: MusicItemID("1494673344"))
                 ?? NilMusicInfo(),
                 playStatus: MusicPlayStatus.Playing
            )  // 아무노래 - ZICO
        )
        friends.append(
            User(id: 6,
                 name: "test user 6",
                 music: await AppleMusicArtworkFinder.default.getMusicInfoBySongID(songID: MusicItemID("1682502298"))
                 ?? NilMusicInfo(),
                 playStatus: MusicPlayStatus.Paused
            )  // ANTIFRAGILE - 르세라핌
        )
    }
}
