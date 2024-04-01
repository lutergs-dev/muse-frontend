//
//  MusicInfoView.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import SwiftUI

struct CurrentUserMusicView: View {
    @ObservedObject var viewModel = MusicInfoViewModel()

    var body: some View {
        VStack {
            // 재생 상태에 따라 색상이 변경되는 박스
            Text(viewModel.playStatus)
                .font(.headline)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .background(viewModel.isPlaying ? Color.green.opacity(0.7) : Color.gray.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 10)

            // 앨범 커버와 음악 정보를 담은 박스
            HStack(alignment: .top) {
                // 앨범 커버 이미지
                if let albumCover = viewModel.currentMusic.artwork {
                    Image(uiImage: albumCover)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
//                        .clipped()
                        .cornerRadius(8)
                        .opacity(viewModel.isPlaying ? 1.0 : 0.5)  // 재생 중이 아닐 때 이미지를 어둡게 처리
                } else {
                    // 이미지 로드 실패시 대체 이미지 또는 색상 표시
                    Rectangle()
                        .fill(Color.secondary.opacity(viewModel.isPlaying ? 0.3 : 0.5))
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                }

                // 음악 정보 텍스트
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.currentMusic.title)  // 곡 제목
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                
                    Spacer()  // 곡 제목을 위로, 앨범명을 아래로 밀어붙이기
                    
                    Text(viewModel.currentMusic.artist)  // 아티스트명
                        .font(.title3)  // 폰트 크기 증가
                        .lineLimit(1)
                    
                    Text(viewModel.currentMusic.album)  // 앨범명
                        .font(.body)  // 폰트 크기 증가
                        .lineLimit(1)
                }
                .padding(.leading, 10)

                Spacer()
            }
            .frame(height: 100)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 10) // 아트워크 하단과 박스 사이의 여백

            Spacer() // VStack 내에서 상단으로 밀어붙임
        }
    }
}
