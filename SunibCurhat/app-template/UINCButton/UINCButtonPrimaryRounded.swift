//
//  UINCButtonPrimaryRounded.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class UINCButtonPrimaryRounded: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = UIColor.custom.blue
                
            } else {
                self.backgroundColor = UIColor.custom.gray
            }
        }
    }
    
    private func setupViews() {
        self.setTitleColor(.white, for: .normal)
        let size_font: CGFloat      = self.titleLabel?.font.pointSize ?? 20.0
        self.layer.cornerRadius     = self.bounds.size.height / 2.0
        self.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOffset     = CGSize(width: 5, height: 5)
        self.layer.shadowRadius     = 5.0
        self.layer.shadowOpacity    = 30.0
        self.layer.masksToBounds    = false
        self.titleLabel?.font       = UIFont.custom.bold.size(of: size_font)
        self.isEnabled              = true
    }
}
