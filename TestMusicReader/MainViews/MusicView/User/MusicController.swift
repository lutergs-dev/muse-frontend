//
//  MusicController.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import MediaPlayer

class MusicController {
    
    func playMusic() {
        MPMusicPlayerController.systemMusicPlayer.play()
    }
    
    func stopMusic() {
        MPMusicPlayerController.systemMusicPlayer.pause()
    }
    
    func nextMusic() {
        MPMusicPlayerController.systemMusicPlayer.skipToNextItem()
    }
    
    func previousMusic() {
        let currentListeningTime = MPMusicPlayerController.systemMusicPlayer.currentPlaybackTime
        if (currentListeningTime < TimeInterval(5.0)) {
            MPMusicPlayerController.systemMusicPlayer.skipToPreviousItem()
        } else {
            MPMusicPlayerController.systemMusicPlayer.skipToBeginning()
        }
    }
}
