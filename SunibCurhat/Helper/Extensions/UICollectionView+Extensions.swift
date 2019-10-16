//
//  UICollectionView+Extensions.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/16/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit

extension UICollectionView {
    func makeInsetCenter() {
        let scaleCell: CGFloat  = 0.6
        let viewController      = UIViewController()
        let screenSize          = UIScreen.main.bounds.size
        let cellWidth           = floor(screenSize.width * scaleCell)
        let cellHeight          = floor(screenSize.height * scaleCell)
        let insetX              = (viewController.view.bounds.width - cellWidth) / 2.0
        let insetY              = (viewController.view.bounds.height - cellHeight) / 2.0
        
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        layout.itemSize     = CGSize(width: cellWidth, height: cellHeight)
        self.contentInset   = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func autoCenterToCellWhileScrollDidFinish(scrollView: UIScrollView, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing   = layout.itemSize.width + layout.minimumLineSpacing
        var offset                      = targetContentOffset.pointee
        let index                       = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex                = round(index)
        offset                          = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee     = offset
    }
}
