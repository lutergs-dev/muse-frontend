//
//  User.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

protocol AbstractUser {
    var id: Int { get set }
    var name: String { get set }
    var music: MusicInfo { get set }
    var playStatus: MusicPlayStatus { get set }
}

class User: Identifiable, AbstractUser, ObservableObject {
    var id: Int = 0
    var name: String = "Muse"
    var music: MusicInfo = AppleMusicInfo()
    var playStatus: MusicPlayStatus = MusicPlayStatus.Stopped
    
    init (id: Int, name: String, music: MusicInfo, playStatus: MusicPlayStatus) {
        self.id = id
        self.name = name
        self.music = music
        self.playStatus = playStatus
    }
    
    // TODO : 다른 user 가 nickname 을 바꿨을 때, refresh 를 어떻게 해줄 것인지에 대한 고민 필요
}
