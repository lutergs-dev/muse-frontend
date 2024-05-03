//
//  LoginView.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginView : View {
    @ObservedObject var viewModel = SignInWithAppleViewModel()

    var body: some View {
        VStack {
            Text("Muse")
                .font(.largeTitle)
                .padding()

            Spacer()
            
            // Google 로그인 버튼
            Button(action: {
                // Google 로그인 로직 실행
            }) {
                HStack {
                    Image("googleLogo") // 로고 이미지는 Assets에 추가해야 합니다.
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Google로 로그인")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            
            VStack {
                SignInWithAppleButton()
                    .frame(height: 44)
                    .padding()
                    .onTapGesture {
                        viewModel.signInWithApple()
                    }
            }

            Spacer()
        }
    }
}
