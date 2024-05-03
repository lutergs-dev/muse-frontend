//
//  SildableFriendView.swift
//  MusicShare
//
//  Created by LVM_mac on 5/3/24.
//

import Foundation
import SwiftUI

struct FriendView: View {
    var user: User
    @State private var isAnimating = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {  // 사용자 이름을 맨 위로, 그 아래에 곡 정보를 표시하기 위한 VStack
            HStack {
                // 재생 상태에 따른 아이콘 변경 및 애니메이션 적용
                if user.playStatus == MusicPlayStatus.Playing {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.green)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                        .onAppear { self.isAnimating = true }
                        .onDisappear { self.isAnimating = false }
                } else {
                    Image(systemName: "pause.circle.fill")
                        .foregroundColor(.gray)
                }

                Text(user.name)  // 사용자 이름
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            HStack(alignment: .top) {
                if let albumCover = user.music.artwork {
                    Image(uiImage: albumCover)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                        .opacity(user.playStatus == MusicPlayStatus.Playing ? 1.0 : 0.5)  // 재생 중이 아닐 때 이미지를 어둡게 처리
                } else {
                    // 이미지 로드 실패시 대체 이미지 또는 색상 표시
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .fill(Color.secondary.opacity(user.playStatus == MusicPlayStatus.Playing ? 0.3 : 0.5))
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(user.music.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.primary)

                    Text(user.music.artist)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(.leading, 5)
                
                Spacer()
            }
        }
    }
}
