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
    @State private var isAnimating = false
    @State private var selectedUser: User?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("친구들이 듣고 있는 음악")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(self.viewModel.$users.friends, id: \.id) { user in
                        Button(action: {
                            self.selectedUser = user.wrappedValue
                        }) {
                            FriendView(user: user.wrappedValue)
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
        .sheet(item: $selectedUser) { user in
            FriendDetailView(user: user)
        }
    }
}

//#Preview {
//    OtherUserMusicView()
//}

struct FriendDetailView: View {
    var user: User

    var body: some View {
        Text("Detail view for \(user.name)")
    }
}
