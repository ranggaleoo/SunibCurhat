//
//  UINCCardCorona.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class UINCCardCorona: UIView {
    var title_color: UIColor? {
        get  {
            return self.lbl_title.textColor
        }
        set {
            return self.lbl_title.textColor = newValue
        }
    }
    
    var body_color: UIColor? {
        get {
            return self.lbl_body.textColor
        }
        set {
            return self.lbl_body.textColor = newValue
        }
    }
    
    var title_size: CGFloat? {
        get {
            return self.lbl_title.font.pointSize
        }
        set {
            guard let size = newValue else { return }
            return self.lbl_title.font = UIFont.custom.bold.size(of: size)
        }
    }
    
    var body_size: CGFloat? {
        get {
            return self.lbl_body.font.pointSize
        }
        set {
            guard let size = newValue else { return }
            return self.lbl_body.font = UIFont.custom.regular.size(of: size)
        }
    }
    
    var title_text: String? {
        get {
            return self.lbl_title.text
        }
        set {
            return self.lbl_title.text = newValue
        }
    }
    
    var body_text: String? {
        get {
            return self.lbl_body.text
        }
        set {
            return self.lbl_body.text = newValue
        }
    }
    
    private lazy var lbl_title: UINCLabelTitle = {
        let lbl = UINCLabelTitle(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        lbl.font = UIFont.custom.bold.size(of: 24)
        lbl.text = "title"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.sizeToFit()
        return lbl
    }()
    
    private lazy var lbl_body: UINCLabelBody = {
        let lbl = UINCLabelBody(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        lbl.font = UIFont.custom.regular.size(of: 18)
        lbl.text = "body"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.sizeToFit()
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.layer.cornerRadius     = self.bounds.size.height / 6.0
        self.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOffset     = CGSize(width: 0, height: 0)
        self.layer.shadowRadius     = 10.0
        self.layer.shadowOpacity    = 30.0
        self.layer.masksToBounds    = false
        
        self.addSubview(lbl_title)
        self.addSubview(lbl_body)
        
        lbl_title.translatesAutoresizingMaskIntoConstraints = false
        lbl_body.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lbl_title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lbl_title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lbl_title.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 8),
            lbl_title.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            lbl_body.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lbl_body.topAnchor.constraint(equalTo: lbl_title.bottomAnchor, constant: -8),
            lbl_body.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -16),
            lbl_body.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 8),
            lbl_body.rightAnchor.constraint(greaterThanOrEqualTo: self.rightAnchor, constant: -8)
        ])
    }
}
