//
//  TestMusicReaderApp.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/1/24.
//

import SwiftUI
import Combine

@main
struct TestMusicReaderApp: App {
    @StateObject private var signInWIthAppleViewModel = SignInWithAppleViewModel()
    @ObservedObject private var currentUser = CurrentUser.shared
    private var mainView = MainView()
    
    var body: some Scene {
        let loginView = LoginView(viewModel: self.signInWIthAppleViewModel)

        WindowGroup {
            if self.currentUser.id == 0 {
                loginView
            } else {
                mainView
            }
        }
    }
}
