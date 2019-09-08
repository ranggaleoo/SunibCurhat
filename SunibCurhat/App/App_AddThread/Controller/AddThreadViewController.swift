//
//  AddThreadViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/12/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class AddThreadViewController: UIViewController {
    @IBOutlet weak var txt_post: UITextView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        configAdUI()
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
    
    private func configAdUI() {
        bannerView.isHidden = true
        MainService.shared.getAdBannerUnitID { (result) in
            switch result {
            case .failure(let e):
                print(e.localizedDescription)
            case .success(let s):
                if s.success {
                    if let ad_unit_id = s.data {
                        self.bannerView.delegate = self
                        self.bannerView.adUnitID = ad_unit_id
                        self.bannerView.rootViewController = self
                        self.bannerView.load(GADRequest())
                    }
                }
            }
        }
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
                    if let vc = self.tabBarController?.viewControllers {
                        guard let navigationController = vc[0] as? UINavigationController else { return }
                        if let c = navigationController.topViewController as? ListCurhatViewController {
                            self.tabBarController?.selectedIndex = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                c.moveFromAddThread()
                            })
                        }
                    }
                    
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

extension AddThreadViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        print_r(title: "ADMOB RECEIVE", message: nil)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print_r(title: "ADMOB ERROR", message: error)
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL PRESENT", message: nil)
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL DISMISS", message: nil)
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB DID DISMISS", message: nil)
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL LEAVE", message: nil)
    }
}
