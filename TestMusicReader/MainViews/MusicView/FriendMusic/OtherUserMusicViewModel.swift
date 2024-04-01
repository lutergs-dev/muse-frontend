//
//  OtherUserMusicViewModel.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import SwiftUI

@MainActor
class OtherUserMusicViewModel: ObservableObject {
    @Published var userViews: [(UserInfo, MusicInfo)] = []
    var userList = dummyUserMusicData
    var timer: Timer?
    
    init() {
        self.userViews = userList.compactMap { user in
            return (user, MusicInfo())
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startTimer),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(stopTimer),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        self.startTimer()
    }
    
    deinit {
        Task {
            await stopTimer()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func startTimer() {
        Task {
            await self.updateUserView()
        }
        // 기존에 실행중인 타이머가 있다면 중지
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 10.0,
            target: self,
            selector: #selector(updateUserViewWrapper),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func updateUserViewWrapper() {
        Task {
            await self.updateUserView()
        }
    }
    
    func updateUserView() async {
        await withTaskGroup(of: (Int, MusicInfo).self) { group in
            for (index, userView) in self.userViews.enumerated() {
                group.addTask {
                    if let musicInfo = await userView.0.music?.getMusicInfo() {
                        return (index, musicInfo)
                    }
                    return (index, MusicInfo())
                }
            }

            // 각 작업의 결과를 수집하고 상태를 업데이트합니다.
            for await (index, musicInfo) in group {
                self.userViews[index] = (self.userViews[index].0, musicInfo)
            }
        }
    }
}
