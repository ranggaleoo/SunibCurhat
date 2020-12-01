//
//  UINCLabelNote.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/12/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class UINCLabelNote: UILabel {
    private var fontSize: CGFloat = 0 {
        didSet {
            self.font = UIFont.custom.regular.size(of: self.fontSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        let size_font: CGFloat  = self.font.pointSize
        self.font = UIFont.custom.regular.size(of: size_font)
        self.textColor = UIColor.custom.gray
    }
    
    public func changeFontSize(size: CGFloat) {
        self.fontSize = size
    }
}
