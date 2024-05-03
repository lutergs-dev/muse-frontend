//
//  LoginViewModel.swift
//  MusicShare
//
//  Created by LVM_mac on 4/7/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

// SwiftUI 뷰에서 Apple 로그인 버튼을 표시하기 위한 구조체
struct SignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
    
    typealias UIViewType = ASAuthorizationAppleIDButton
}

// Apple 로그인 처리를 위한 뷰모델
class SignInWithAppleViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    // Apple 로그인 성공 시 호출됩니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            DispatchQueue.main.async {
                let userIdentifier = appleIDCredential.user
             
                HttpRequester.shared.post(
                    requestUrl: Variables.backendServer + "/user/login",
                    header: nil,
                    body: ["type": "APPLE", "uid": userIdentifier],
                    cookies: nil
                ){ result in
                    switch result {
                    case .success(let response):
                        do {
                            let responseUser = try JSONDecoder().decode(ResponseUser.self, from: response.body)
                            CurrentUser.shared.setUserId(id: responseUser.id ?? 0)
                            CurrentUser.shared.setUserName(name: responseUser.info.name)
                            CurrentUser.shared.setFriends(friends: responseUser.info.friends)
                            
                            // extract cookie
                            if let headerFields = response.response.allHeaderFields as? [String: String], let url = response.response.url {
                                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                                if let userTokenCookie = cookies.first( where: { $0.name == "project_muse"}) {
                                    CurrentUser.shared.setUserToken(cookies: [userTokenCookie])
                                } else {
                                    print("cookie subtraction failed!")
                                }
                            }
                            
                            print("UserSession? : \(UserDefaults.standard.userId)")
                        } catch {
                            print("JSON parsing fail!")
                        }
                    case .failure(let error):
                        print("Failed to Login!")
                    }
                }
            }
        }
    }
    
    // Apple 로그인 실패 시 호출됩니다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패 처리
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}
