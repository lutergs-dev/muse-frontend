//
//  FriendInfo.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

struct User: Identifiable {
    var id: Int
    var name: String
    var music: UserMusic? = nil
    
    // TODO : 다른 user 가 nickname 을 바꿨을 때, refresh 를 어떻게 해줄 것인지에 대한 고민 필요
    
    mutating func changeMusic(music: UserMusic) {
        self.music = music
    }
}

let dummyUserMusicData = [
    User(id: 1, name: "test user 1", music: UserAppleMusic.fromSongID(rawSongID: "1613139922")),  // TOMBOY - (여자) 아이들
    User(id: 2, name: "test user 2", music: UserAppleMusic.fromSongID(rawSongID: "1621089608")),  // FEARLESS - 르세라핌
    User(id: 3, name: "test user 3", music: UserAppleMusic.fromSongID(rawSongID: "1519364407")),  // How You Like That - BLACKPINK
    User(id: 4, name: "test user 4", music: nil),  // 재생 중 아님
    User(id: 5, name: "test user 5", music: UserAppleMusic.fromSongID(rawSongID: "1494673344")),  // 아무노래 - ZICO
    User(id: 6, name: "test user 6", music: UserAppleMusic.fromSongID(rawSongID: "1682502298"))  // ANTIFRAGILE - 르세라핌
]
