//
//  PremiumViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/10/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class PremiumViewController: UIViewController {
    
    @IBOutlet weak var premiumCollectionView: UICollectionView!
    @IBOutlet weak var premiumTableView: UITableView!
    
    var subscriptions   : [SubscriptionPremiumUserResponse] = []
    var advantages      : [AdvantagePremiumUserResponse]    = []
    
    var indexSelectedSubs: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        addData()
    }
    
    private func delegates() {
        self.title = "Upgrade PRO"
        
        premiumCollectionView.makeInsetCenter()
        premiumCollectionView.delegate      = self
        premiumCollectionView.dataSource    = self
        premiumTableView.delegate           = self
        premiumTableView.dataSource         = self
    }
    
    private func addData() {
        let urlSubs = "https://semuabisa.ga/public/assets/image/bisa_quota_data/operator/main_games.jpg"
        let urlAdv = "https://semuabisa.ga/public/assets/image/logo.jpg"
        
        subscriptions.append(SubscriptionPremiumUserResponse(type: "Lifetime", price: 50000, image: urlSubs))
        subscriptions.append(SubscriptionPremiumUserResponse(type: "Monthly", price: 10000, image: urlSubs))
        
        advantages.append(AdvantagePremiumUserResponse(name: "No Ads", content: "No Ads No Ads No Ads", image: urlAdv))
        advantages.append(AdvantagePremiumUserResponse(name: "Badge User Premium", content: "No Ads No Ads No Ads", image: urlAdv))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toPayment":
            if let dest = segue.destination as? PaymentWebViewController {
                debugLog(dest)
            }
        default: return
        }
    }
}
