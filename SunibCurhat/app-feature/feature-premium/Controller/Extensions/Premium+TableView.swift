//
//  Premium+TableView.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/11/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

extension PremiumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumSubscriptionTableViewCell", for: indexPath) as! PremiumSubscriptionTableViewCell
        cell.subscription = subscriptions[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelectedSubs = indexPath.item
        performSegue(withIdentifier: "toPayment", sender: self)
    }
}
