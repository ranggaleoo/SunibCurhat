//
//  UINCLabelClickable.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class UINCLabelClickable: UILabel {
    var clickables: [String: (() -> Void)] = [:] {
        didSet {
            self.setupViews()
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
        self.isUserInteractionEnabled = true
        guard let text = self.text else { return }
        let size_font: CGFloat  = self.font.pointSize
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        if let matchTexts = matches {
            for match in matchTexts {
                print(match)
                print(match.replacementString ?? "")
                print(match.alternativeStrings ?? "")
                guard let range = Range(match.range, in: text) else { continue }
                let url_text = "\(text[range])"
                if let url = URL(string: url_text) {
                    self.clickables[url_text] = { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
                }
            }
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        clickables.forEach { (s, f) in
            let r = (text as NSString).range(of: s)
            attributedString.addAttribute(.foregroundColor, value: UIColor.custom.blue_absolute, range: r)
            attributedString.addAttribute(.font, value: UIFont.custom.bold.size(of: size_font), range: r)
        }
        self.attributedText = attributedString
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clicked(_:))))
    }
    
    @objc private func clicked(_ tap: UITapGestureRecognizer) {
        guard let text = self.text else { return }
        clickables.forEach { (s, f) in
            let r = (text as NSString).range(of: s)
            if tap.didTapAttributeInLabel(label: self, inRange: r) {
                f()
            }
        }
    }
}
