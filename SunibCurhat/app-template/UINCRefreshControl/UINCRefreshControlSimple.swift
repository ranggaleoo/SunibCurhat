//
//  UINCRefreshControlSimple.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 20/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class UINCRefreshControlSimple: UIRefreshControl {
    private let spinnerView: UIImageView = {
        let imageView = UIImageView(image: UIImage(symbol: .Circle)) // Add an image of a spinning wheel
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UINCColor.primary
        return imageView
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Hide the default indicator view
        self.tintColor = UIColor.clear
        self.attributedTitle = NSAttributedString(string: "")
        
        addSubview(spinnerView)
        layoutSpinnerView()
    }
    
    private func layoutSpinnerView() {
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: 40), // Adjust size as needed
            spinnerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        animateBounce()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        stopAnimating()
    }
    
    private func animateBounce() {
        UIView.animate(withDuration: 0.3, animations: {
            // Scale down the spinner
            self.spinnerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
                // Scale up the spinner with a bounce effect
                self.spinnerView.transform = .identity
            }, completion: nil)
        }
    }
    
    private func stopAnimating() {
        spinnerView.layer.removeAllAnimations()
    }
}
