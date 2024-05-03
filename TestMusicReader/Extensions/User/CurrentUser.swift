//
//  UserSession.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import Combine
import KeychainSwift

class CurrentUser: ObservableObject {
    // private values
    @Published private(set) var id: Int
    @Published private(set) var name: String
    @Published private(set) var music: MusicInfo
    @Published private(set) var playStatus: MusicPlayStatus
    @Published private(set) var friendIds: [Int]
    
    private let keychain: KeychainSwift
    private let tokenName: String
    
    private let idBackgroundPublisher = PassthroughSubject<Int, Never>()
    private let nameBackgroundPublisher = PassthroughSubject<String, Never>()
    private let musicBackgroundPublisher = PassthroughSubject<MusicInfo, Never>()
    private let playStatusBackgroundPublisher = PassthroughSubject<MusicPlayStatus, Never>()
    private let friendAddBackgroundPublisher = PassthroughSubject<Int, Never>()
    private let friendRemoveBackgroundPublisher = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    public static let shared = CurrentUser()
    
    private init() {
        
        // 초기 값 설정
        self.id = UserDefaults.standard.userId
        self.name = UserDefaults.standard.userName ?? "Muse"
        self.music = NilMusicInfo()
        self.playStatus = MusicPlayStatus.Stopped
        self.friendIds = []
        self.keychain = KeychainSwift()
        self.tokenName = "MuseToken"
        
        UserDefaults.standard.publisher(for: \.userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.id = $0 }
            .store(in: &cancellables)
        
        UserDefaults.standard.publisher(for: \.userName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.name = $0 ?? "Muse" }
            .store(in: &cancellables)
        
        self.registerSubscription()
    }
    
    public func logout() {
        DispatchQueue.global().async {
            UserDefaults.standard.userId = 0
            UserDefaults.standard.userName = nil
            self.idBackgroundPublisher.send(0)
            self.nameBackgroundPublisher.send("Muse")
            self.musicBackgroundPublisher.send(NilMusicInfo())
            self.playStatusBackgroundPublisher.send(MusicPlayStatus.Stopped)
        }
        self.keychain.delete(self.tokenName)
    }
    
    public func setUserId(id: Int) {
        DispatchQueue.global().async {
            self.idBackgroundPublisher.send(id)
            UserDefaults.standard.userId = id
        }
    }
    
    public func setUserName(name: String) {
        DispatchQueue.global().async {
            self.nameBackgroundPublisher.send(name)
            UserDefaults.standard.userName = name
        }
    }
    
    public func setFriends(friends: [Int]) {
        DispatchQueue.global().async {
            friends.forEach { friend in
                self.friendAddBackgroundPublisher.send(friend)
            }
        }
    }
    
    public func changePlayStatus(playStatus: MusicPlayStatus) {
        DispatchQueue.global().async {
            self.playStatusBackgroundPublisher.send(playStatus)
        }
        HttpRequester.shared.post(
            requestUrl: Variables.backendServer + "/track/status",
            header: nil,
            body: ["status": self.playStatus.rawValue],
            cookies: self.getUserToken()
        ) { result in }
    }
    
    public func changeMusic(music: MusicInfo) {
        DispatchQueue.global().async {
            self.musicBackgroundPublisher.send(music)
        }
        HttpRequester.shared.post(
            requestUrl: Variables.backendServer + "/track",
            header: nil,
            body: [
                "vendor": self.music.provider.rawValue,
                "uid": self.music.uid
            ],
            cookies: self.getUserToken()
        ) { result in }
    }
    
    public func setUserToken(cookies: [HTTPCookie]) {
        do {
            let secureCookies = cookies.compactMap { $0.properties }.map { SecureHTTPCookie(with: $0) }
            let cookiesData = try NSKeyedArchiver.archivedData(withRootObject: secureCookies, requiringSecureCoding: true)
            self.keychain.set(cookiesData, forKey: self.tokenName)
        } catch {
            print("Fail to archive cookies to data: \(error)")
        }
    }
        
    public func getUserToken() -> [HTTPCookie]? {
        if let cookieData = self.keychain.getData(self.tokenName) {
            do {
                let cookies = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: SecureHTTPCookie.self, from: cookieData)
                return cookies
            } catch {
                print("Fail to unarchive data to cookies: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func registerSubscription() {
        self.idBackgroundPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newId in
                self?.id = newId
            })
            .store(in: &self.cancellables)
        self.nameBackgroundPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newName in
                self?.name = newName
            })
            .store(in: &self.cancellables)
        self.musicBackgroundPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newMusicInfo in
                self?.music = newMusicInfo
            })
            .store(in: &self.cancellables)
        self.playStatusBackgroundPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newPlayStatus in
                self?.playStatus = newPlayStatus
            })
            .store(in: &self.cancellables)
        self.friendAddBackgroundPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newFriend in
                self?.friendIds.append(newFriend)
            })
            .store(in: &self.cancellables)
        self.friendRemoveBackgroundPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] removeFriend in
                self?.friendIds.removeAll { $0 == removeFriend }
            })
            .store(in: &self.cancellables)
    }
}
