//
//  ListCurhatViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class ListCurhatViewController: UIViewController {
    
    @IBOutlet weak var tableViewCurhat: UITableView!
    @IBOutlet weak var admob_unit_1: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        configAdUnit()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clicked)))
    }
    
    @objc func clicked() {
        print("--------clicked")
        self.showLoaderIndicator()
        TimelineService.shared.getTimeline { (result) in
            switch result {
            case .failure(let error):
                self.dismissLoaderIndicator()
                self.showAlert(title: "Error", message: error.localizedDescription + "\n Try Again?", OKcompletion: { (act) in
                    self.clicked()
                }, CancelCompletion: { (act) in
                    RepoMemory.token = nil
                })
                
                print(error)
            case .success(let success):
                self.dismissLoaderIndicator()
                self.showAlert(title: "Success", message: success.message, OKcompletion: { (act) in
                    self.clicked()
                }, CancelCompletion: nil)
                print(success)
            }
        }
    }
    
    private func delegates() {
        tableViewCurhat.delegate = self
        tableViewCurhat.dataSource = self
    }
    
    private func configAdUnit() {
        admob_unit_1.delegate = self
        admob_unit_1.alpha = 0
        admob_unit_1.adUnitID = ConstGlobal.AdMOB_UNIT_ID_TEST_BANNER
        admob_unit_1.rootViewController = self
        admob_unit_1.load(GADRequest())
    }
}

extension ListCurhatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurhatTableViewCell") as! CurhatTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListCurhatViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        admob_unit_1.alpha = 0
        UIView.animate(withDuration: 1) {
            self.admob_unit_1.alpha = 1
        }
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
