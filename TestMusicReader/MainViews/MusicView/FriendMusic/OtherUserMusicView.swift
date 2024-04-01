//
//  OtherUserMusicView.swift
//  TestMusicReader
//
//  Created by LVM_mac on 4/3/24.
//

import Foundation
import UIKit
import SwiftUI

struct OtherUserMusicView: View {
    @ObservedObject var viewModel = OtherUserMusicViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("친구들이 듣고 있는 음악")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(self.viewModel.userViews, id: \.0.id) { userView in
                        VStack(alignment: .leading, spacing: 8) {  // 사용자 이름을 맨 위로, 그 아래에 곡 정보를 표시하기 위한 VStack
                            Text(userView.0.name)  // 사용자 이름
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack(alignment: .top) {
                                if let albumCover = userView.1.artwork {
                                    Image(uiImage: albumCover)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                //                        .clipped()
                                        .cornerRadius(4)
    //                                    .opacity(viewModel.isPlaying ? 1.0 : 0.5)  // 재생 중이 아닐 때 이미지를 어둡게 처리
                                } else {
                                    // 이미지 로드 실패시 대체 이미지 또는 색상 표시
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
    //                                    .fill(Color.secondary.opacity(viewModel.isPlaying ? 0.3 : 0.5))
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(4)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text(userView.1.title)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .foregroundColor(.primary)

                                    Text(userView.1.artist)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .padding(.leading, 5)
                                
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .padding(.top, 2)
                    }
                }
            }
        }
    }
}

#Preview {
    OtherUserMusicView()
}
