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
    
    private var containerView: UIView!
    private var contentView: UIView!
    private var closeButton: UIButton?
    
    var heightFraction: CGFloat = 0.5 // Default to half the screen
    var showCloseButton: Bool = true
    var dynamicContentView: UIView?
    
    init(heightFraction: CGFloat = 0.5, showCloseButton: Bool = true, contentView: UIView? = nil) {
        self.heightFraction = heightFraction
        self.showCloseButton = showCloseButton
        self.dynamicContentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGesture()
        setupContent()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightFraction).isActive = true
        
        if showCloseButton {
            closeButton = UIButton(type: .system)
            closeButton?.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            closeButton?.tintColor = .gray
            closeButton?.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
            containerView.addSubview(closeButton!)
            
            closeButton?.translatesAutoresizingMaskIntoConstraints = false
            closeButton?.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
            closeButton?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        }
    }
    
    private func setupContent() {
        guard let contentView = dynamicContentView else { return }
        
        containerView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: showCloseButton ? closeButton!.bottomAnchor : containerView.topAnchor, constant: 16).isActive = true
        contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        view.addGestureRecognizer(tapGesture)
    }
    
    func show(on parentview: UIViewController, completion: (() -> Void)?) {
        modalPresentationStyle = .overCurrentContext
        parentview.present(self, animated: true, completion: completion)
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }
}
