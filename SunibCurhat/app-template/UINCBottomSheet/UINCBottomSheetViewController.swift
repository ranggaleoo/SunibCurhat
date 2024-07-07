//
//  UINCBottomSheetViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/07/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class UINCBottomSheetViewController: UIViewController {
    
    // Create a container for dynamic content
    private let contentView = UIView()
    private var contentHeightConstraint: NSLayoutConstraint?
    
    // Optional close button
    private let closeButton = UIButton(type: .system)
    var showCloseButton: Bool = false {
        didSet {
            closeButton.isHidden = !showCloseButton
        }
    }
    
    // Enum to define height modes
    enum HeightMode {
        case dynamic
        case fixed(CGFloat)
        case ratio(CGFloat)
    }
    
    var heightMode: HeightMode = .dynamic {
        didSet {
            updateHeightConstraint()
        }
    }
    
    // Add any dynamic content here
    var dynamicContent: UIView? {
        didSet {
            setupDynamicContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomSheet()
    }
    
    private func setupBottomSheet() {
        // Setup the view's appearance
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        // Add contentView to the view
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        // Add close button to the contentView
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        closeButton.isHidden = !showCloseButton
        contentView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup Auto Layout constraints
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        contentHeightConstraint?.isActive = true
        
        updateHeightConstraint()
        
        // Add a tap gesture recognizer to dismiss the bottom sheet
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupDynamicContent() {
        // Remove previous content if any
        contentView.subviews.forEach { if $0 != closeButton { $0.removeFromSuperview() } }
        
        guard let dynamicContent = dynamicContent else { return }
        
        // Add new dynamic content
        contentView.addSubview(dynamicContent)
        dynamicContent.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup Auto Layout constraints for dynamic content
        NSLayoutConstraint.activate([
            dynamicContent.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            dynamicContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dynamicContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dynamicContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        if case .dynamic = heightMode {
            contentHeightConstraint?.isActive = false
        }
    }
    
    private func updateHeightConstraint() {
        contentHeightConstraint?.isActive = false
        
        switch heightMode {
        case .dynamic:
            contentHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        case .fixed(let height):
            contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: height)
        case .ratio(let ratio):
            contentHeightConstraint = contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ratio)
        }
        
        contentHeightConstraint?.isActive = true
    }
    
    func show(on view: UIViewController, _ completion: (() -> Void)? = nil) {
        view.present(self, animated: true, completion: completion)
    }
    
    @objc private func dismissBottomSheet() {
        dismiss(animated: true, completion: nil)
    }
}
