//
//  OtherUserMusicViewAlpha.swift
//  MusicShare
//
//  Created by LVM_mac on 5/3/24.
//

import Foundation
import SwiftUI

struct OtherUserMusicView2: View {
    @ObservedObject var viewModel = OtherUserMusicViewModel()
    @State private var draggedState: [Int: CGFloat] = [:] // 각 사용자의 드래그 상태를 관리
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("친구들이 듣고 있는 음악")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(self.viewModel.$users.friends, id: \.id) { user in
                        ZStack(alignment: .trailing) {
                            // 슬라이드하여 표시할 버튼
                            Button(action: {
                                print("\(user.name.wrappedValue) deleted")
                                // 친구 삭제 로직을 여기에 구현
                            }) {
                                Text("Delete")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 90)
                                    .background(Color.red)
                            }
                            
                            // 사용자 카드
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(user.name.wrappedValue)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    // 음악 정보 뷰
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .offset(x: self.draggedState[user.id] ?? 0) // 드래그 상태에 따른 오프셋 적용
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if value.translation.width < 0 { // 왼쪽으로만 드래그 가능
                                            self.draggedState[user.id] = value.translation.width
                                        }
                                    }
                                    .onEnded { value in
                                        if value.translation.width < -100 {
                                            self.draggedState[user.id] = -90
                                        } else {
                                            self.draggedState[user.id] = 0
                                        }
                                    }
                            )
                        }
                    }
                }
            }
            .onTapGesture {
                // 다른 곳을 탭하면 모든 카드를 원래 위치로
                for id in self.draggedState.keys {
                    self.draggedState[id] = 0
                }
            }
        }
    }
}
