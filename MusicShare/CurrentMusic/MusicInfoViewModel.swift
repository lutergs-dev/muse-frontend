//
//  MusicInfoViewModel.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import MediaPlayer
import UIKit

class MusicInfoViewModel: ObservableObject {
    @Published var currentMusic = MusicInfo()
    @Published var playStatus = "음악을 재생 중이 아닙니다!"
    @Published var isPlaying: Bool = false
    private var musicFinder = AppleMusicArtworkFinder()
    
    init() {
        subscribeToChange()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(subscribeToChange),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(unsubscribeFromChange),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func subscribeToChange() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(nowPlayingItemChanged),
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playbackStateChanged),
            name: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
        nowPlayingItemChanged()
        playbackStateChanged()
    }
    
    @objc private func unsubscribeFromChange() {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
    }
    
    @objc private func nowPlayingItemChanged() {
        DispatchQueue.main.async {
            let musicPlayer = MPMusicPlayerController.systemMusicPlayer
            if let nowPlayingItem = musicPlayer.nowPlayingItem {
                self.currentMusic = MusicInfo.fromMPMediaItem(item: nowPlayingItem)
                if (self.currentMusic.artwork == nil) {
                    Task {
                        if let artworkImage = await self.musicFinder.getMusicArtwork(item: nowPlayingItem) {
                            print("set artwork")
                            self.currentMusic.setArtworkIfNotSame(image: artworkImage)
                        }
                    }
                }
            } else {
                self.currentMusic = MusicInfo()
            }
        }
        
    }
    
    @objc private func playbackStateChanged() {
        DispatchQueue.main.async {
            self.setPlaybackStatus(state: MPMusicPlayerController.systemMusicPlayer.playbackState)
        }
    }
    
    private func setPlaybackStatus(state: MPMusicPlaybackState?) {
        switch state {
        case .stopped:
            self.isPlaying = false
            self.playStatus = "음악을 재생 중이 아닙니다!"
        case .playing:
            self.isPlaying = true
            self.playStatus = "재생 중"
        case .paused:
            self.isPlaying = false
            self.playStatus = "일시정지"
        default:
            self.isPlaying = false
            self.playStatus = self.playStatus
        }
    }
}
