//
//  HttpRequester.swift
//  MusicShare
//
//  Created by LVM_mac on 4/30/24.
//

import Foundation

class HttpRequester {
    
    private let session: URLSession
    
    static let shared = HttpRequester()
    
    private init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpCookieAcceptPolicy = .always
        self.session = URLSession(configuration: sessionConfig)
    }
    
    func post(
        requestUrl: String,
        header: [String: String]?,
        body: [String: Any]?,
        cookies: [HTTPCookie]?,
        completion: @escaping (Result<HTTPResponse, Error>) -> Void
    ) {
        guard let url = URL(string: requestUrl) else {
            completion(.failure(HttpException.InvalidUrlException("Not valid URL")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        header?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let cookies = cookies {
            let cookiesHeaderField = HTTPCookie.requestHeaderFields(with: cookies)
            if let cookiesHeader = cookiesHeaderField["Cookie"] {
                request.addValue(cookiesHeader, forHTTPHeaderField: "Cookie")
            }
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(HttpException.JsonParseException("Failed to parse JSON : \(body)")))
                return
            }
        }
        
        let task = self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(HttpException.InvalidResponse("Invalid Response")))
                return
            }
            
            let result = HTTPResponse(
                response: httpResponse,
                body: data ?? Data()
            )
            
            completion(.success(result))
        }
        task.resume()
    }
    
    func request() {
        
    }
 
}
