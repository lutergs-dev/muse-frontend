//
//  UserSession.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import Combine


class CurrentUser: ObservableObject {
    // private values
    @Published private var privateId: Int
    @Published private var privateName: String
    @Published private var privateMusic: MusicInfo
    @Published private var privatePlayStatus: MusicPlayStatus
    @Published private var privateFriendIds: [Int]
    
    // public read-only publisher
    var id: AnyPublisher<Int, Never> { $privateId.eraseToAnyPublisher() }
    var name: AnyPublisher<String, Never> { $privateName.eraseToAnyPublisher() }
    var music: AnyPublisher<MusicInfo, Never> { $privateMusic.eraseToAnyPublisher() }
    var playStatus: AnyPublisher<MusicPlayStatus, Never> { $privatePlayStatus.eraseToAnyPublisher() }
    var friendIds: AnyPublisher<[Int], Never> { $privateFriendIds.eraseToAnyPublisher() }
    
    private let keychain: KeychainSwift
    private let tokenName: String
    private var cancellables = Set<AnyCancellable>()
    
    public static let shared = CurrentUser()
    
    private init() {
        // 초기 값 설정
        self.privateId = UserDefaults.standard.userId
        self.privateName = UserDefaults.standard.userName ?? "Muse"
        self.privateMusic = NilMusicInfo()
        self.privatePlayStatus = MusicPlayStatus.Stopped
        self.privateFriendIds = []
        
        UserDefaults.standard.publisher(for: \.userId)
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.privateId = $0 }
            .store(in: &cancellables)
        
        UserDefaults.standard.publisher(for: \.userName)
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.privateName = $0 ?? "Muse" }
            .store(in: &cancellables)
        
        self.keychain = KeychainSwift()
        self.tokenName = "MuseToken"
    }
    
    public func logout() {
        UserDefaults.standard.userId = 0
        UserDefaults.standard.userName = nil
        self.privateId = 0
        self.privateName = "Muse"
        self.privateMusic = NilMusicInfo()
        self.privatePlayStatus = MusicPlayStatus.Stopped
        self.keychain.delete(self.tokenName)
    }
    
    public func changePlayStatus(playStatus: MusicPlayStatus) {
        self.privatePlayStatus = playStatus
        HttpRequester.shared.post(
            requestUrl: Variables.backendServer + "/track/status",
            header: nil,
            body: ["status": self.privatePlayStatus.rawValue]
        ) { result in }
    }
    
    public func changeMusic(music: MusicInfo) {
        self.privateMusic = music
        HttpRequester.shared.post(
            requestUrl: Variables.backendServer + "/track",
            header: nil,
            body: [
                "vendor": self.privateMusic.provider.rawValue,
                "uid": self.privateMusic.uid
            ]
        ) { result in }
    }
    
    public func getUserToken() -> String? {
        return self.keychain.get(self.tokenName)
    }
    
    public func setUserToken(value: String) {
        self.keychain.set(value, forKey: self.tokenName)
    }
}
