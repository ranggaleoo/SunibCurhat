//
//  HTTPRequest.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

class HTTPRequest {
    static let shared: HTTPRequest = {
        return HTTPRequest()
    }()
    
    let task = URLSession.shared
    var timeoutInterval: TimeInterval = 60
    var headers: [HTTPRequestHeader.key : String] = [:]
    
    func connect<T:Decodable>( url: String, params: [String:Any]?, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let _url = URL(string: url) else {
            fatalError("invalid url: " + url)
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = params == nil ? "GET" : "POST"
        request.timeoutInterval = self.timeoutInterval
        
        if headers.count > 0 {
            headers.forEach { (k, v) in
                request.addValue(v, forHTTPHeaderField: k.string)
            }
        }
        
        if let param = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options:[])
            } catch let e {
                print(e.localizedDescription)
                completion(.failure(e))
            }
        }
        
        self.task.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let a = response as? HTTPURLResponse {
                    if a.statusCode != 200 {
                        let e = NSError(domain: "Status Code", code: a.statusCode, userInfo: nil)
                        completion(.failure(e))
                    }
                    print("status code: ", a.statusCode)
                }
                if let _data = data, let stringResponse = String(data: _data, encoding: .utf8) {
                    print(stringResponse)
                    
                    do {
                        let responseModel = try JSONDecoder().decode(T.self, from: _data)
                        completion(.success(responseModel))
                    } catch let jsonError {
                        completion(.failure(jsonError))
                    }
                }
            }
        }.resume()
    }
}
