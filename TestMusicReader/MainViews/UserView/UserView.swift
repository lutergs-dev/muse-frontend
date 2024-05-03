//
//  UserView.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import SwiftUI
import Combine

struct UserView: View {
    @ObservedObject private var currentUser = CurrentUser.shared
    @State private var searchText = ""
    @State private var isSearching = false
    
    private var sampleUsers: [UserTest] = [
        UserTest(id: 5, name: "search"),
        UserTest(id: 6, name: "text"),
        UserTest(id: 8, name: "useruser"),
        UserTest(id: 12, name: "omg"),
        UserTest(id: 15, name: "lutergss"),
        UserTest(id: 23, name: "test_user"),
        UserTest(id: 26, name: "한글유저"),
        UserTest(id: 33, name: "_..__"),
        UserTest(id: 40, name: "ㅋㅋ"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if !isSearching {
                Text("\(currentUser.name) 님, 안녕하세요!")
                    .font(.title)
                    .bold()
            }
            
            // 검색바
            HStack {
                TextField("사용자 검색...", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation {
                        isSearching = isEditing
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if isSearching {
                    Button("취소") {
                        searchText = ""
                        withAnimation {
                            isSearching = false
                        }
                        // 키보드 숨기기
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .padding(.trailing, 10)
                }
            }
            
            // 추천 유저 목록 및 검색 결과
            ScrollView {
                ForEach(searchResults, id: \.self) { user in
                    Text(user.name)
                        .padding()
                }
            }
            
            Spacer()
            
            Button(action: {
                self.currentUser.logout()
            }) {
                Text("로그아웃")
                    .padding()
            }
        }
        .padding(.horizontal)
    }
    
    // 검색 로직
    var searchResults: [UserTest] {
        if searchText.isEmpty {
            // TODO : 더미 데이터
            return self.sampleUsers
        } else {
            return self.sampleUsers.filter { $0.name.contains(searchText) }
        }
    }
}

struct UserTest: Identifiable, Hashable {
    var id: Int
    var name: String
}
