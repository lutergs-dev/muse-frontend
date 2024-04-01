//
//  ButtonView.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    // views
    private let currentUserMusicView = CurrentUserMusicView()
    private let otherUserMusicView = OtherUserMusicView()
    
    
    // data for Button
    @State private var showMenu = false
    @State public var selectedMenu: Menus = Menus.MusicMenu
    @State private var buttonAnimationStates: [Menus: Bool] = [Menus.MusicMenu: false, Menus.UserMenu: false, Menus.SettingMenu: false]
    private static let iconSize: CGFloat = 60
    private var mainCoordinate: Coordinate {
        return (x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 150)
    }
    private var coordinates: [Menus: Coordinate] {
        return [
            Menus.MusicMenu: (x: mainCoordinate.x - 120, y: mainCoordinate.y),
            Menus.UserMenu: (x: mainCoordinate.x - 84.85, y: mainCoordinate.y - 84.85),
            Menus.SettingMenu: (x: mainCoordinate.x, y: mainCoordinate.y - 120)
        ]
    }
    
    var body: some View {
        ZStack {
            
            switch (self.selectedMenu) {
                case .MusicMenu:
                    VStack {
                        self.currentUserMusicView
                            .padding(.bottom, 15)
                        self.otherUserMusicView
                    }
                case .UserMenu:
                    VStack {
                        Text("UserMenu")
                            .font(.title2)
                            .bold()
                    }
                case .SettingMenu:
                    VStack {
                        Text("SettingMenu")
                            .font(.title2)
                            .bold()
                    }
            }
            
            ZStack {
                // 배경 흐림 효과
                if showMenu {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.showMenu = false
                            }
                        }
                }
                
                // 메인 버튼과 서브 버튼
                mainButton
                subButtons
            }.animation(.easeInOut, value: showMenu)  // 전체 뷰에 애니메이션 적용
        
    
        }
    }
    
    
    var mainButton: some View {
        Circle()
            .fill(Color.indigo)
            .frame(width: MainView.iconSize, height: MainView.iconSize)
            .overlay(
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            )
            .shadow(radius: 4)
            .position(x: self.mainCoordinate.x, y: self.mainCoordinate.y)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in self.showMenu = true }
                    .onEnded { value in self.showMenu = false; executeMenuAction(at: value.location) }
            )
    }
    
    var subButtons: some View {
        Group {
            subButton(iconName: "music.note", coordinateKey: Menus.MusicMenu)
            subButton(iconName: "person.badge.plus", coordinateKey: Menus.UserMenu)
            subButton(iconName: "gearshape.fill", coordinateKey: Menus.SettingMenu)
        }
    }
    
    func subButton(iconName: String, coordinateKey: Menus) -> some View {
        let initialOpacity: Double = showMenu ? 1 : 0

        return Circle()
            .fill(Color.purple)
            .frame(width: MainView.iconSize, height: MainView.iconSize)
            .overlay(
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.largeTitle)
            )
            .shadow(radius: 4)
            .opacity(buttonAnimationStates[coordinateKey]! ? initialOpacity : 0)
            .offset(
                x: showMenu ? 0 : -(self.coordinates[coordinateKey]!.x - self.mainCoordinate.x) / 5,
                y: showMenu ? 0 : -(self.coordinates[coordinateKey]!.y - self.mainCoordinate.y) / 5
            )
//            .offset(x: initialOffset, y: initialOffset)
            .position(x: self.coordinates[coordinateKey]!.x, y: self.coordinates[coordinateKey]!.y)
            .animation(.easeInOut(duration: 0.25), value: showMenu)
            .onAppear {
                withAnimation {
                    self.buttonAnimationStates[coordinateKey] = true
                }
            }
            .onDisappear {
                withAnimation {
                    self.buttonAnimationStates[coordinateKey] = false
                }
            }
    }

    func executeMenuAction(at location: CGPoint) {
        print("exeucte Action!")
        // 여기서 location을 기반으로 어떤 메뉴 항목이 선택되었는지 판단하고 해당 기능을 실행
        if location.x <= self.coordinates[Menus.MusicMenu]!.x + MainView.iconSize &&
            location.y > self.coordinates[Menus.UserMenu]!.y + MainView.iconSize {
            self.selectedMenu = Menus.MusicMenu
            print("기능 1")
        } else if location.x < self.coordinates[Menus.UserMenu]!.x + MainView.iconSize &&
                    location.y < self.coordinates[Menus.UserMenu]!.y + MainView.iconSize {
            self.selectedMenu = Menus.UserMenu
            print("기능 2")
        } else if location.x >= self.coordinates[Menus.UserMenu]!.x + MainView.iconSize &&
                    location.y < self.coordinates[Menus.SettingMenu]!.y + MainView.iconSize {
            self.selectedMenu = Menus.SettingMenu
            print("기능 3")
        } else {
            print("기능 선택 안함")
        }
    }
}

#Preview {
    MainView()
}
