//
//  UINCInputArea.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

protocol UINCInputAreaDelegate: AnyObject {
    func didGetInput(inputAreaView: UINCInputArea, text: String, valid: ValidationResult) -> Void
}

class UINCInputArea: UIView {
    @IBOutlet private weak var stack_container: UIStackView!
    @IBOutlet private weak var lbl_field: UINCLabelTitle!
    @IBOutlet private weak var lbl_status_field: UINCLabelNote!
    @IBOutlet private weak var txt_field: UITextView!
    
    weak var delegate: UINCInputAreaDelegate?
    
    private var validations: [ValidationType] = []
    private var placeholder: String? = nil {
        didSet {
            txt_field.text = placeholder
        }
    }
    
    var isEnabled: Bool {
        didSet {
            txt_field.isEditable = isEnabled
        }
    }
    
    required init?(coder: NSCoder) {
        isEnabled = true
        super.init(coder: coder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        isEnabled = true
        super.init(frame: frame)
        setupViews()
    }
    
    
    private func setupViews() {
        // Load the view from the XIB file
        if let view = Bundle.main.loadNibNamed(String(describing: UINCInputArea.self), owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
            addSubview(view)
            
            stack_container.spacing = 8
            txt_field.delegate = self
            txt_field.text                  = placeholder
            txt_field.isScrollEnabled       = false
            txt_field.backgroundColor       = UINCColor.bg_secondary
            txt_field.textColor             = UIColor.label
            txt_field.layer.borderColor     = UIColor.tertiaryLabel.cgColor
            txt_field.layer.borderWidth     = 1.0
            txt_field.layer.cornerRadius    = txt_field.bounds.size.height / 8.0
            txt_field.layer.masksToBounds   = false
            
            lbl_status_field.isHidden = true
            lbl_status_field.numberOfLines = 0
            lbl_status_field.textColor = UINCColor.error
            lbl_status_field.changeFontSize(size: 12)
       }
    }
    
    private func isValid() -> ValidationResult {
        var result: ValidationResult = ValidationResult(error: "")
        for validate in validations {
            let valid = validate.isValid(txt_field.text ?? "")
            if !valid.isSuccess {
                result = valid
                break
            } else {
                result = valid
            }
        }
        
        return result
    }
    
    func add(validation: ValidationType) -> UINCInputArea {
        validations.append(validation)
        return self
    }
    
    func set(label: String) -> UINCInputArea {
        lbl_field.text = label
        return self
    }
    
    func set(placeholder: String) -> UINCInputArea {
        self.placeholder = placeholder
        return self
    }
    
    func set(status: String) -> UINCInputArea {
        lbl_status_field.isHidden = false
        lbl_status_field.text = status
        return self
    }
    
    func set(statusColor: UIColor) -> UINCInputArea {
        txt_field.layer.borderColor  = statusColor.cgColor
        txt_field.layer.borderWidth  = 2.0
        return self
    }
    
    func hideStatus() -> UINCInputArea {
        lbl_status_field.text = nil
        lbl_status_field.isHidden = true
        return self
    }
    
    func hideLabel() -> UINCInputArea {
        lbl_field.isHidden = true
        return self
    }
    
    func addConstraints(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, centerX: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, centerYConstant: CGFloat = 0, centerXConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        if self.superview == nil {
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top, constant: topConstant)
            constraint.identifier = "top"
            constraints.append(constraint)
        }
        
        if let left = left {
            let constraint = leftAnchor.constraint(equalTo: left, constant: leftConstant)
            constraint.identifier = "left"
            constraints.append(constraint)
        }
        
        if let bottom = bottom {
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
            constraint.identifier = "bottom"
            constraints.append(constraint)
        }
        
        if let right = right {
            let constraint = rightAnchor.constraint(equalTo: right, constant: -rightConstant)
            constraint.identifier = "right"
            constraints.append(constraint)
        }

        if let centerY = centerY {
            let constraint = centerYAnchor.constraint(equalTo: centerY, constant: centerYConstant)
            constraint.identifier = "centerY"
            constraints.append(constraint)
        }

        if let centerX = centerX {
            let constraint = centerXAnchor.constraint(equalTo: centerX, constant: centerXConstant)
            constraint.identifier = "centerX"
            constraints.append(constraint)
        }
        
        if widthConstant > 0 {
            let constraint = widthAnchor.constraint(equalToConstant: widthConstant)
            constraint.identifier = "width"
            constraints.append(constraint)
        }
        
        if heightConstant > 0 {
            let constraint = heightAnchor.constraint(equalToConstant: heightConstant)
            constraint.identifier = "height"
            constraints.append(constraint)
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    func top(to: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) -> UINCInputArea {
        _ = addConstraints(top: to, topConstant: constant)
        return self
    }
    
    func bottom(to: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) -> UINCInputArea {
        _ = addConstraints(bottom: to, bottomConstant: constant)
        return self
    }
    
    func left(to: NSLayoutXAxisAnchor, _ constant: CGFloat = 0) -> UINCInputArea {
        _ = addConstraints(left: to, leftConstant: constant)
        return self
    }
    
    func right(to: NSLayoutXAxisAnchor, _ constant: CGFloat = 0) -> UINCInputArea {
        _ = addConstraints(right: to, rightConstant: constant)
        return self
    }
}

extension UINCInputArea: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (cs) in
            if cs.firstAttribute == .height {
                DispatchQueue.main.async {
                    cs.constant = estimateSize.height
                }
            }
        }
        
        if let txt_plcholder = placeholder, textView.text == txt_plcholder {
            // do nothing
        } else {
            let validate = self.isValid()
            if(!validate.isSuccess) {
                _ = set(status: validate.error ?? "")
                    .set(statusColor: UINCColor.error)
                
            } else {
                _ = hideStatus()
                    .set(statusColor: UINCColor.primary)
            }
            
            delegate?.didGetInput(inputAreaView: self, text: textView.text, valid: validate)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let txt_plcholder = placeholder, textView.text == txt_plcholder {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty, let txt_plcholder = placeholder {
            textView.text = txt_plcholder
            textView.textColor = UIColor.tertiaryLabel
        }
    }
}
