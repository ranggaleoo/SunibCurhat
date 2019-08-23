//
//  AddThreadViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/12/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class AddThreadViewController: UIViewController {
    @IBOutlet weak var txt_post: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
    }
    
    private func delegates() {
        self.title = "Add Thread"
        txt_post.delegate = self
        txt_post.isScrollEnabled = false
        txt_post.text = "What is in your heart?"
        txt_post.textColor = UIColor.custom.gray
        textViewDidChange(txt_post)
        self.endEditing()
    }
    
    func addThread() -> Void {
        guard txt_post.textColor != UIColor.custom.gray && txt_post.text.count > ConstGlobal.MINIMUM_TEXT else {
            self.showAlert(title: "Error", message: "Write what you feel, at least \(ConstGlobal.MINIMUM_TEXT) character", OKcompletion: nil, CancelCompletion: nil)
            return
        }
        
        self.showLoaderIndicator()
        AddThreadService.shared.addThread(text_content: txt_post.text) { (result) in
            switch result {
            case .failure(let e):
                self.dismissLoaderIndicator()
                self.showAlert(title: "Error", message: e.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    RepoMemory.token = nil
                    RepoMemory.pendingFunction = self.addThread.self
                }, CancelCompletion: nil)
                
            case .success(let s):
                self.dismissLoaderIndicator()
                if s.success {
                    print(s.message)
                    self.tabBarController?.selectedIndex = 0
                    
                } else {
                    self.showAlert(title: "Error", message: s.message + "\n Try Again?", OKcompletion: { (act) in
                        self.addThread()
                    }, CancelCompletion: nil)
                }
            }
        }
    }
    
    @IBAction func actionPostThread(_ sender: UIButton) {
        addThread()
    }
}

extension AddThreadViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.view.frame.width - 32, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (cs) in
            if cs.firstAttribute == .height {
                DispatchQueue.main.async {
                    cs.constant = estimateSize.height
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.custom.gray {
            textView.text = nil
            textView.textColor = UIColor.custom.black_absolute
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What is in your heart?"
            textView.textColor = UIColor.custom.gray
        }
    }
}
