//
//  PaymentWebViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/2/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PaymentWebViewController: WKWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var param: [String: Any] = [:]
        param["type"]   = "bank_local"
        param["method"] = "bca_local"
        param["amount"] = 50000
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        
        headers[.referer]       = URLConst.server_sb
        headers[.authorization] = "Bearer " + ConstGlobal.API_SEMUABISA
        load(url: URLConst.api_url_sb + "/paymentWebView", params: param)
    }
    
    private func handleJson(webview: WKWebView, completion: @escaping (Result<MainResponse<PaymentResponse>, Error>) -> Void) {
        getJson(webView: webview, model: MainResponse<PaymentResponse>.self) { (result) in
            print(result)
            completion(result)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            let responseRange = 200...299
            let is200 = responseRange.contains(response.statusCode)
            
            if !is200 {
                if let nav = navigationController {
                    nav.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        decisionHandler(.allow)
    }
    
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        handleJson(webview: webView) { (result) in
            switch result {
            case .failure(let e):
                print(e.localizedDescription)
            case .success(let s):
            }
        }
    }
}

struct PaymentResponse: Decodable {
    var type        : String
    var id_trx      : Int
    var method      : String
    var amount      : Int
    var destination : String
    var time        : String
    
    enum Keys: String, CodingKey {
        case type
        case id_trx
        case method
        case amount
        case destination
        case time
    }
    
    init(from decoder: Decoder) throws {
        let container       = try decoder.container(keyedBy: Keys.self)
        self.type           = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.id_trx         = try container.decodeIfPresent(Int.self, forKey: .id_trx) ?? 0
        self.method         = try container.decodeIfPresent(String.self, forKey: .method) ?? ""
        self.amount         = try container.decodeIfPresent(Int.self, forKey: .amount) ?? 0
        self.destination    = try container.decodeIfPresent(String.self, forKey: .destination) ?? "Content"
        self.time           = try container.decodeIfPresent(String.self, forKey: .time) ?? ""
    }
}
