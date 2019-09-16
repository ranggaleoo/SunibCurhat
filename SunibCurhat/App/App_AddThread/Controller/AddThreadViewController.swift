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
    @IBOutlet weak var btn_post: UIButton!
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var lbl_eula: UILabel!
    
    let termText    = "By clicking on the \"Post\" button, you agree to our User Agreement and our Privacy Policy"
    let eulaText    = "User Agreement"
    let privacyText = "Privacy Policy"
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                DispatchQueue.main.async {
                    self.btn_check.setImage(UIImage(named: "btn_check_box"), for: .normal)
                    self.btn_post.isEnabled = true
                    self.btn_post.backgroundColor = UIColor.custom.blue
                }
                
            } else {
                DispatchQueue.main.async {
                    self.btn_check.setImage(UIImage(named: "btn_uncheck_box"), for: .normal)
                    self.btn_post.isEnabled = false
                    self.btn_post.backgroundColor = UIColor.custom.gray
                }
            }
            
            UDHelpers.shared.set(value: isChecked, key: Bundle.main.bundleIdentifier ?? "Sunib" + ".EulaIsChecked")
        }
    }
    
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
        
        let formattedText = String.format(
            strings: [self.eulaText, self.privacyText],
            boldFont: UIFont.boldSystemFont(ofSize: 12),
            boldColor: UIColor.custom.blue,
            inString: self.termText,
            font: UIFont.systemFont(ofSize: 12),
            color: UIColor.black)
        lbl_eula.attributedText = formattedText
        lbl_eula.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEulaTapped(gesture:)))
        lbl_eula.addGestureRecognizer(tap)
        lbl_eula.isUserInteractionEnabled = true
        
        let isChecked = UDHelpers.shared.getBool(key: Bundle.main.bundleIdentifier ?? "Sunib" + ".EulaIsChecked")
        self.isChecked = isChecked
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
    
    @IBAction func actionCheck(_ sender: UIButton) {
        let checked = self.isChecked
        self.isChecked = !checked
    }
    
    @objc func handleEulaTapped(gesture: UITapGestureRecognizer) {
        let termString = termText as NSString
        let termRange = termString.range(of: self.eulaText)
        let policyRange = termString.range(of: self.privacyText)
        
        let tapLocation = gesture.location(in: lbl_eula)
        let index = lbl_eula.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if checkRange(termRange, contain: index) == true {
            guard let url_eula = URL(string: "https://bit.ly/uelasunibcurhat") else {return}
            if UIApplication.shared.canOpenURL(url_eula) {
                UIApplication.shared.open(url_eula, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- user agreement")
                    }
                })
            }
            return
        }
        
        if checkRange(policyRange, contain: index) {
            guard let url_privacy = URL(string: "https://bit.ly/privacypolicesunib") else {return}
            if UIApplication.shared.canOpenURL(url_privacy) {
                UIApplication.shared.open(url_privacy, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- open privacy policy")
                    }
                })
            }
            return
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
