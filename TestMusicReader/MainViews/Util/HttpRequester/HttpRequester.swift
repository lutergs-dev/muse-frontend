//
//  HttpRequester.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

class HttpRequester {
    
    static let shared = HttpRequester()
    
    private init() {}
    
    func post(requestUrl: String, header: [String: String], body: [String: Any]) {
        if let url = URL(string: requestUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            header.forEach { key, value in
                request.setValue(key, forHTTPHeaderField: value)
            }
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
            }
        }
    }
    
    func request() {
        
    }
 
}
