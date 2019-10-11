//
//  Premium+CollectionView.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/11/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

extension PremiumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advantages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PremiumAdvantageCollectionViewCell", for: indexPath) as! PremiumAdvantageCollectionViewCell
        cell.advantage = advantages[indexPath.item]
        return cell
    }
}
