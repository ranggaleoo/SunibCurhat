//
//  UINCInput.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

protocol UINCInputDelegate: AnyObject {
    func didGetInput(inputView: UINCInput, text: String, valid: ValidationResult) -> Void
}

class UINCInput: UIView {
    @IBOutlet private weak var stack_container: UIStackView!
    @IBOutlet private weak var lbl_field: UINCLabelTitle!
    @IBOutlet private weak var lbl_status_field: UINCLabelNote!
    @IBOutlet private weak var txt_field: UITextField!
    
    weak var delegate: UINCInputDelegate?
    
    private var validations: [ValidationType] = []
    
    var isEnabled: Bool {
        didSet {
            txt_field.isEnabled = isEnabled
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
        if let view = Bundle.main.loadNibNamed(String(describing: UINCInput.self), owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
            addSubview(view)
            
            stack_container.spacing = 8
            txt_field.delegate = self
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
    
    func add(validation: ValidationType) -> UINCInput {
        validations.append(validation)
        return self
    }
    
    func set(type: UINCInputType) -> UINCInput {
        switch type {
        case .email:
            _ = set(label: "Email")
                .set(placeholder: "input email")
            txt_field.keyboardType = .emailAddress
            validations.append([.isNotBlank, .isEmail])
        case .password:
            _ = set(label: "Password")
                .set(placeholder: "input password")
            txt_field.isSecureTextEntry = true
            validations.append([.isNotBlank, .isGreaterThanOrEqual8, .isContainLowercase, .isContainUppercase, .isContainNumber])
        case .confirm_password:
            _ = set(label: "Confirm Password")
                .set(placeholder: "type password again")
            txt_field.isSecureTextEntry = true
            validations.append([.isNotBlank])
        }
        return self
    }
    
    func set(label: String) -> UINCInput {
        lbl_field.text = label
        return self
    }
    
    func set(placeholder: String) -> UINCInput {
        txt_field.placeholder = placeholder
        return self
    }
    
    func set(status: String) -> UINCInput {
        lbl_status_field.isHidden = false
        lbl_status_field.text = status
        return self
    }
    
    func set(statusColor: UIColor) -> UINCInput {
        txt_field.layer.borderColor  = statusColor.cgColor
        txt_field.layer.borderWidth  = 2.0
        txt_field.layer.cornerRadius = 5.0
        return self
    }
    
    func hideStatus() -> UINCInput {
        lbl_status_field.text = nil
        lbl_status_field.isHidden = true
        return self
    }
    
    func hideLabel() -> UINCInput {
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
    
    func top(to: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) -> UINCInput {
        _ = addConstraints(top: to, topConstant: constant)
        return self
    }
    
    func bottom(to: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) -> UINCInput {
        _ = addConstraints(bottom: to, bottomConstant: constant)
        return self
    }
    
    func left(to: NSLayoutXAxisAnchor, _ constant: CGFloat = 0) -> UINCInput {
        _ = addConstraints(left: to, leftConstant: constant)
        return self
    }
    
    func right(to: NSLayoutXAxisAnchor, _ constant: CGFloat = 0) -> UINCInput {
        _ = addConstraints(right: to, rightConstant: constant)
        return self
    }
}

extension UINCInput: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validate = self.isValid()
        if(!validate.isSuccess) {
            _ = set(status: validate.error ?? "")
                .set(statusColor: UINCColor.error)
            
        } else {
            _ = hideStatus()
                .set(statusColor: UINCColor.primary)
        }
        delegate?.didGetInput(inputView: self, text: textField.text ?? "", valid: validate)
        return true
    }
}

enum UINCInputType: String {
    case email
    case password
    case confirm_password
}

enum ValidationType: String {
    case isBlank
    case isNotBlank
    case isEmail
    case isGreaterThanOrEqual8
    case isContainLowercase
    case isContainUppercase
    case isContainNumber
    case isContainSpecialCharacter
}

extension ValidationType {
    func isValid(_ text: String) -> ValidationResult {
        switch self {
        case .isBlank:
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return text.isEmpty ? ValidationResult() : ValidationResult(error: "Has Text")
        case .isNotBlank:
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return !text.isEmpty ? ValidationResult() : ValidationResult(error: "Required")
        case .isEmail:
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: text) ? ValidationResult() : ValidationResult(error: "Invalid Email")
        case .isGreaterThanOrEqual8:
            return text.count >= 8 ? ValidationResult() : ValidationResult(error: "minimum password 8 character")
        case .isContainLowercase:
            return text.rangeOfCharacter(from: .lowercaseLetters) != nil ? ValidationResult() : ValidationResult(error: "at least password contains one lowercase -> a-z")
        case .isContainUppercase:
            return text.rangeOfCharacter(from: .uppercaseLetters) != nil ? ValidationResult() : ValidationResult(error: "at least password contains one uppercase -> A-Z")
        case .isContainNumber:
            return text.rangeOfCharacter(from: .decimalDigits) != nil ? ValidationResult() : ValidationResult(error: "at least password contains one number -> 0-9")
        case .isContainSpecialCharacter:
            let specialCharacterSet = CharacterSet(charactersIn: "@$!%*?&")
            return text.rangeOfCharacter(from: specialCharacterSet) != nil ? ValidationResult() : ValidationResult(error: "at least password contains one special charater from the set -> @$!%*?&")
        }
    }
}

struct ValidationResult {
    var isSuccess: Bool = true
    var error: String?
    
    init(error: String? = nil) {
        if(error == nil) {
            self.isSuccess = true
        } else {
            self.isSuccess = false
            self.error = error
        }
    }
}
