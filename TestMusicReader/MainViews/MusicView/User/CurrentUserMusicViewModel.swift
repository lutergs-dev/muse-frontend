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
    @Published var user: UserSession = UserSession.shared
    @Published var playStatus: String = "음악을 재생 중이 아닙니다!"
    private let musicFinder = AppleMusicArtworkFinder()
    private let musicPlayer = MusicController()
    
    init() {
        // 앱의 백그라운드 / 포그라운드 상태와 상관없이, 무조건 음악 재생이 변경되면 POST 요청을 날려야 함.
        subscribeToChange()
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(subscribeToChange),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil
//        )
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(unsubscribeFromChange),
//            name: UIApplication.didEnterBackgroundNotification,
//            object: nil
//        )
    }
    
    public func playMusic() {
        if (self.user.playStatus == MusicPlayStatus.Playing) {
            self.musicPlayer.stopMusic()
        } else {
            self.musicPlayer.playMusic()
        }
    }
    
    public func nextMusic() {
        self.musicPlayer.nextMusic()
    }
    
    public func previousMusic() {
        self.musicPlayer.previousMusic()
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
                self.user.music = AppleMusicInfo.fromMPMediaItem(item: nowPlayingItem)
                
                // send current music playing
                
                
                
                if (self.user.music.artwork == nil) {
                    Task {
                        if let artworkImage = await self.musicFinder.getMusicArtwork(item: nowPlayingItem) {
                            self.user.music.artwork = artworkImage
                        }
                    }
                }
            } else {
                self.user.music = AppleMusicInfo()
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
            self.user.playStatus = MusicPlayStatus.Stopped
            self.playStatus = "음악을 재생 중이 아닙니다!"
        case .playing:
            self.user.playStatus = MusicPlayStatus.Playing
            self.playStatus = "재생 중"
        case .paused:
            self.user.playStatus = MusicPlayStatus.Paused
            self.playStatus = "일시정지"
        default:
            self.user.playStatus = MusicPlayStatus.Stopped
            self.playStatus = self.playStatus
        }
    }
}
