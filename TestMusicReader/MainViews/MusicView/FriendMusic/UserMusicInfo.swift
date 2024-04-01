//
//  UserMusicInfo.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation

struct UserInfo: Identifiable {
    var id = UUID()
    var name: String = ""
    var music: UserMusic? = nil
}

let dummyUserMusicData = [
    UserInfo(id: UUID(), name: "test user 1", music: UserAppleMusic.fromSongID(rawSongID: "1613139922")),  // TOMBOY - (여자) 아이들
    UserInfo(id: UUID(), name: "test user 2", music: UserAppleMusic.fromSongID(rawSongID: "1621089608")),  // FEARLESS - 르세라핌
    UserInfo(id: UUID(), name: "test user 3", music: UserAppleMusic.fromSongID(rawSongID: "1519364407")),  // How You Like That - BLACKPINK
    UserInfo(id: UUID(), name: "test user 4", music: nil),  // 재생 중 아님
    UserInfo(id: UUID(), name: "test user 5", music: UserAppleMusic.fromSongID(rawSongID: "1494673344")),  // 아무노래 - ZICO
    UserInfo(id: UUID(), name: "test user 6", music: UserAppleMusic.fromSongID(rawSongID: "1682502298"))  // ANTIFRAGILE - 르세라핌
]
