//
//  WKWebViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/2/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {
    
    var timeoutInterval: TimeInterval = 60
    var headers: [HTTPRequestHeader.key : String] = [:]
    private var isRequestJson: Bool = false
    
    var url: URL? {
        get {
            return self.webview.url
        }
    }
    
    private lazy var webview: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let wv = WKWebView(frame: CGRect(x: 0, y: minimumHeight, width: view.bounds.width, height: view.bounds.height))
        wv.navigationDelegate = self
        wv.addObserver(self, forKeyPath: "_ESTIMATED_PROGRESS_WEB_VIEW_", options: .new, context: nil)
        wv.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) { wv.scrollView.contentInsetAdjustmentBehavior = .never }
        return wv
    }()
    
    private lazy var progressView: UIProgressView = {
        let pv = UIProgressView(frame: CGRect(x: 0, y: minimumHeight, width: view.frame.width, height: 10))
        pv.progressTintColor = UIColor.blue
        pv.trackTintColor = UIColor.lightGray
        return pv
    }()
    
    private lazy var minimumHeight: CGFloat = {
        let navigationHeight = navigationController?.navigationBar.frame.size.height ?? 0.0
        let statusbarHeight  = UIApplication.shared.statusBarFrame.size.height
        return navigationHeight + statusbarHeight
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webview)
        self.view.addSubview(progressView)
        self.view.bringSubviewToFront(progressView)
        
        if #available(iOS 11.0, *) {
            self.webview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.webview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        self.webview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.webview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.webview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "_ESTIMATED_PROGRESS_WEB_VIEW_" {
            self.progressView.progress = Float(self.webview.estimatedProgress)
        }
    }
    
    func loadWebView(url: String, params: [String: Any]?) {
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
            }
        }
        self.webview.load(request)
    }
    
    func loadWebViewWithJson<T:Decodable>(url: String, params: [String: Any]?, model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        isRequestJson = true
        loadWebView(url: url, params: params)
        
        NotificationCenter.default.addObserver(forName: .webViewDidFinish, object: nil, queue: .some(.main)) { (n) in
            self.isRequestJson = false
            self.webview.evaluateJavaScript("document.getElementsByTagName('pre')[0].innerHTML", completionHandler: { (result, error) in
                if let e = error {
                    completion(.failure(e))
                }
                
                if let _result = result as? String {
                    if let _data = _result.data(using: .utf8) {
                        do {
                            let responseModel = try JSONDecoder().decode(T.self, from: _data)
                            completion(.success(responseModel))
                        } catch let jsonError {
                            completion(.failure(jsonError))
                        }
                        
                    } else {
                        completion(.failure(NSError(domain: "result is cannot convert to data with encode utf8", code: 100, userInfo: nil)))
                    }
                    
                } else {
                    completion(.failure(NSError(domain: "result is not String or html", code: 100, userInfo: nil)))
                }
            })
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isRequestJson {
            NotificationCenter.default.post(name: .webViewDidFinish, object: nil)
        }
        DispatchQueue.main.async {
            self.progressView.removeFromSuperview()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.progressView.removeFromSuperview()
        }
    }
}

extension NSNotification.Name {
    static let webViewDidFinish = NSNotification.Name(rawValue: Bundle.main.bundleIdentifier! + ".webViewDidFinish")
}
