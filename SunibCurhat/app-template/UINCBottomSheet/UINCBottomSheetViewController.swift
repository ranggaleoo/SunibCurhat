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

    enum HeightMode {
        case fixed(CGFloat)
        case dynamic
        case ratio(CGFloat)
    }
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 26
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    private var showCloseButton: Bool = true {
        didSet {
            closeButton?.isHidden = !showCloseButton
        }
    }
    
    var heightMode: HeightMode = .dynamic {
        didSet {
            self.updateHeight()
        }
    }
   
    
    private var dynamicContentView: UIView?
    private var closeButton: UIButton?
    private var HEIGHT_CONTENT_MINIMUM: CGFloat = 250
    
    init(contentView: UIView? = nil) {
        self.dynamicContentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    func set(height mode: HeightMode) {
        self.heightMode = mode
    }
    
    func set(showCloseButton: Bool) {
        self.showCloseButton = showCloseButton
    }
    
    private func updateHeight() {
        switch heightMode {
        case .dynamic:
            break // No height constraint, content will dictate the height
        case .fixed(let height):
            let heightBottomSheet = view.bounds.height
            var realHeight = height >= heightBottomSheet ? heightBottomSheet - 80 : height
            realHeight = realHeight <= HEIGHT_CONTENT_MINIMUM ? HEIGHT_CONTENT_MINIMUM + 80 : realHeight
            containerView.heightAnchor.constraint(equalToConstant: realHeight).isActive = true
        case .ratio(let height):
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: height).isActive = true
        }
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
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        updateHeight()
        
        if showCloseButton {
            closeButton = UIButton(type: .system)
            closeButton?.setImage(UIImage(symbol: .XmarkCircleFill, configuration: .init(scale: .large)), for: .normal)
            closeButton?.tintColor = .gray
            closeButton?.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
            containerView.addSubview(closeButton!)
            
            closeButton?.translatesAutoresizingMaskIntoConstraints = false
            closeButton?.heightAnchor.constraint(equalToConstant: 30).isActive = true
            closeButton?.widthAnchor.constraint(equalToConstant: 30).isActive = true
            closeButton?.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
            closeButton?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        }
        view.bringSubviewToFront(containerView)
    }
    
    private func setupContent() {
        guard let contentView = dynamicContentView else { return }
        
        containerView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: showCloseButton ? closeButton!.bottomAnchor : containerView.topAnchor, constant: 16).isActive = true
        contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        contentView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16).isActive = true
        containerView.bringSubviewToFront(contentView)
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
