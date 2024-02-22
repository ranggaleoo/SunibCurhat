//
//  HTTPRequest.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation


//struct HTTPRequestCurrentTask<T:Decodable> {
//    let url: String
//    let params: [String:Any]?
//    let model: T.Type
//    let completion: ((Result<T, Error>) -> Void)
//}
//
//struct HTTPRequestMiddleware {
//    let middleware_id: String
//    let middleware: ((_ request: HTTPRequest) -> Void)
//}
//
//extension HTTPRequestMiddleware: Equatable {
//    static func == (lhs: HTTPRequestMiddleware, rhs: HTTPRequestMiddleware) -> Bool {
//        return rhs.middleware_id == lhs.middleware_id
//    }
//}

class HTTPRequest: NSObject {
    static let shared: HTTPRequest = {
        return HTTPRequest()
    }()
    
    @available(*, deprecated, renamed: "sess", message: "unused session: URLSession!")
    var session: URLSession!
    let task = URLSession.shared
//    let currentTask: Any?
    var timeoutInterval: TimeInterval = 60
    var headers: [HTTPRequestHeader.key : String] = [:]
    var method: HTTPRequestMethod?
    
    private var statusCode: Int? = nil
//    private var middlewares: [HTTPRequestMiddleware] = []
    
//    override init() {
//        debugLog("init httprequest")
//        add(id: "handle401") { request in
//            if let statusCode = request.getStatusCode(), statusCode == 401 {
//                MainService.shared.refreshToken { (result) in
//                    switch result {
//                    case .failure(let err):
//                        // what need to do? login page? session expired
//                        break
//                    case .success(let res):
//                        if let token = res.data, res.success {
//                            //success get token
//                            UDHelpers.shared.set(value: token, key: .access_token)
//                            //retry the function before.
//                            if let current = request.currentTask as? HTTPRequestCurrentTask {
//                                request.connect(url: current.url, params: current.params, model: current.model, completion: current.completion)
//                            }
//                        } else {
//                            // something wrong, session expired navigate to login
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    private func resetValueToDefault() {
        timeoutInterval = 60
        headers.removeAll()
        method = nil
    }
    
    func getStatusCode() -> Int? {
        return self.statusCode
    }
    
//    func add(id: String, middleware: @escaping ((_ request: HTTPRequest) -> Void)) {
//        let httpMiddleware = HTTPRequestMiddleware(middleware_id: "handle401", middleware: middleware)
//        if !middlewares.contains(httpMiddleware) {
//            middlewares.append(httpMiddleware)
//        }
//    }
    
    func connect<T:Decodable>( url: String, params: [String:Any]?, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        //reset everything here
        statusCode = nil
//        let current = HTTPRequestCurrentTask(url: url, params: params, model: model, completion: completion)
//        self.currentTask = current
        
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
        
        if let _method = self.method {
            request.httpMethod = _method.rawValue
        }
        
        if let param = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options:[])
            } catch let e {
                debugLog(e.localizedDescription)
                completion(.failure(e))
            }
        }
        
        task.configuration.httpShouldSetCookies = true
        task.configuration.httpCookieAcceptPolicy = .always
        
        self.task.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let responses = response as? HTTPURLResponse {
                    debugLog("status code", responses.statusCode)
//                    debugLog("headers: \(responses.allHeaderFields)")
                    
                    if let _data = data, let stringResponse = String(data: _data, encoding: .utf8) {
                        debugLog(stringResponse)
                        
                        self?.statusCode = responses.statusCode
                        if let urlRefresh = URL(string: URLConst.server + URLConst.path_v1 + "/auth/refresh/"),
                           responses.statusCode == 401 {
                            
                            let refreshToken = UDHelpers.shared.getString(key: .refresh_token)
                            var requestRefresh = URLRequest(url: urlRefresh)
                            requestRefresh.httpMethod = "GET"
                            requestRefresh.timeoutInterval = self?.timeoutInterval ?? 60
                            requestRefresh.addValue(refreshToken, forHTTPHeaderField: "Authorization")
                            
                            self?.task.dataTask(with: requestRefresh, completionHandler: { data, response, error in
                                DispatchQueue.main.async {
                                    if let err = error {
                                        completion(.failure(err))
                                        return
                                    }
                                    
                                    if let responses = response as? HTTPURLResponse {
                                        debugLog("status code", responses.statusCode)
                                        
                                        if let _data = data, let stringResponse = String(data: _data, encoding: .utf8) {
                                            debugLog(stringResponse)
                                            
                                            self?.statusCode = responses.statusCode
                                            
                                            do {
                                                let responseRefresh = try JSONDecoder().decode(MainResponse<RefreshTokenData>.self, from: _data)
                                                if responseRefresh.success,
                                                   let dToken = responseRefresh.data {
                                                    UDHelpers.shared.set(value: dToken.access_token, key: .access_token)
                                                    
                                                    let access_token = UDHelpers.shared.getString(key: .access_token)
                                                    let auth = "Bearer \(access_token)"
                                                    request.setValue(auth, forHTTPHeaderField: "Authorization")
                                                    self?.retryRequest(request: request, model: model, completion: completion)
                                                } else {
                                                    let errorRefresh = NSError(domain: responseRefresh.message, code: 1, userInfo: nil)
                                                    completion(.failure(errorRefresh))
                                                }
                                                
                                            } catch let jsonError {
                                                debugLog(jsonError)
                                                completion(.failure(jsonError))
                                            }
                                        }
                                    }
                                }
                            }).resume()
                            
                        } else {
                            do {
                                let responseModel = try JSONDecoder().decode(T.self, from: _data)
                                completion(.success(responseModel))
                            } catch let jsonError {
                                debugLog(jsonError)
                                completion(.failure(jsonError))
                            }
                        }
                    }
                }
            }
        }.resume()
        resetValueToDefault()
    }
    
    func retryRequest<T:Decodable>(request: URLRequest, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        self.task.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let err = error {
                    completion(.failure(err))
                    return
                }
                
                if let responses = response as? HTTPURLResponse {
                    debugLog("status code", responses.statusCode)
                    
                    if let _data = data, let stringResponse = String(data: _data, encoding: .utf8) {
                        debugLog(stringResponse)
                        
                        self.statusCode = responses.statusCode
                        
                        do {
                            let responseModel = try JSONDecoder().decode(T.self, from: _data)
                            completion(.success(responseModel))
                        } catch let jsonError {
                            debugLog(jsonError)
                            completion(.failure(jsonError))
                        }
                    }
                }
            }
        }.resume()
        resetValueToDefault()
    }
}
