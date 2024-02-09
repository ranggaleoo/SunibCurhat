//
//  RegisterView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

class RegisterView: UIViewController, RegisterPresenterToView {
    var presenter: RegisterViewToPresenter?
    
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var stack_container: UIStackView!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var lbl_status: UINCLabelNote!
    @IBOutlet weak var lbl_login: UINCLabelClickable!
    @IBOutlet weak var lbl_agreement: UINCLabelClickable!
    @IBOutlet weak var btn_register: UINCButtonPrimaryRounded!
    private lazy var input_email: UINCInput = UINCInput()
    private lazy var input_password: UINCInput = UINCInput()
    private lazy var input_confirm_password: UINCInput = UINCInput()
    
    init() {
        super.init(nibName: String(describing: RegisterView.self), bundle: Bundle(for: RegisterView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        view.backgroundColor = UINCColor.bg_primary
        image_view.backgroundColor = UINCColor.bg_secondary
        image_view.contentMode = .scaleAspectFill
        image_view.clipsToBounds = true
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        let image_url = preferences?.images.image_url_register ?? ""
        image_view.image = nil
        
        if let url = URL(string: image_url) {
            image_view.kf.setImage(with: url)
        }
        
        let view_email = UIView()
        let view_password = UIView()
        let view_confirm_passowrd = UIView()
        
        view_email.addSubview(input_email)
        view_password.addSubview(input_password)
        view_confirm_passowrd.addSubview(input_confirm_password)
        
        input_email
            .set(type: .email)
            .left(to: view_email.leftAnchor, 64)
            .right(to: view_email.rightAnchor, 64)
            .top(to: view_email.topAnchor)
            .bottom(to: view_email.bottomAnchor)
            .delegate = self
        
        input_password
            .set(type: .password)
            .left(to: view_password.leftAnchor, 64)
            .right(to: view_password.rightAnchor, 64)
            .top(to: view_password.topAnchor)
            .bottom(to: view_password.bottomAnchor)
            .delegate = self
        
        input_confirm_password
            .set(type: .confirm_password)
            .left(to: view_confirm_passowrd.leftAnchor, 64)
            .right(to: view_confirm_passowrd.rightAnchor, 64)
            .top(to: view_confirm_passowrd.topAnchor)
            .bottom(to: view_confirm_passowrd.bottomAnchor)
            .delegate = self
        
        stack_container.insertArrangedSubview(view_email, at: 1)
        stack_container.insertArrangedSubview(view_password, at: 2)
        stack_container.insertArrangedSubview(view_confirm_passowrd, at: 3)
        stack_container.spacing = 16
        
        lbl_status.numberOfLines = 0
        lbl_status.changeFontSize(size: 14)
        lbl_status.textColor = UINCColor.error
        lbl_status.isHidden = true
        
        lbl_login.numberOfLines = 0
        lbl_login.textAlignment = .center
        lbl_login.text = "Already have an account? Login"
        lbl_login.clickables["Login"] = { [weak self] in
            self?.presenter?.didClickLogin()
        }
        
        lbl_agreement.numberOfLines = 0
        lbl_agreement.textAlignment = .center
        lbl_agreement.changeFontSize(size: 12)
        lbl_agreement.text = "By clicking on the \"Register\" button, you agree to our User Agreement and our Privacy Policy"
        lbl_agreement.clickables["User Agreement"] = { [weak self] in
            self?.presenter?.didClickAgreement()
        }
        lbl_agreement.clickables["Privacy Policy"] = { [weak self] in
            self?.presenter?.didClickPrivacyPolicy()
        }
        
        btn_register.setTitle("Register", for: .normal)
        
        btn_register.isEnabled = false
        
        view_container.backgroundColor = UINCColor.bg_primary
        view_container.roundCorners([.topLeft, .topRight], radius: view_container.width/6)
    }
    
    func showFailRegisterMessage(text: String) {
        input_email
            .set(statusColor: UINCColor.error)
            .isEnabled = true
        input_password
            .set(statusColor: UINCColor.error)
            .isEnabled = true
        input_confirm_password
            .set(statusColor: UINCColor.error)
            .isEnabled = true
        
        lbl_login.isUserInteractionEnabled = true
        lbl_agreement.isUserInteractionEnabled = true
        
        lbl_status.isHidden = false
        lbl_status.text = text
    }
    
    func startLoader() {
        input_email.isEnabled = false
        input_password.isEnabled = false
        input_confirm_password.isEnabled = false
        lbl_login.isUserInteractionEnabled = false
        lbl_agreement.isUserInteractionEnabled = false
        btn_register.startAnimate()
    }
    
    func stopLoader(isSuccess: Bool, completion: (() -> Void)?) {
        if isSuccess {
            btn_register.stopAnimate(style: .expand, refertAfterDelay: 1) {
                completion?()
            }
        } else {
            btn_register.stopAnimate(style: .shake)
        }
    }
    
    @IBAction func didClickRegister(_ sender: Any) {
        presenter?.didClickRegister()
    }
}

extension RegisterView: UINCInputDelegate {
    func didGetInput(inputView: UINCInput, text: String, valid: ValidationResult) {
        if(inputView == input_email) {
            presenter?.set(email: valid.isSuccess ? text : nil)
        }
        
        if(inputView == input_password) {
            presenter?.set(password: valid.isSuccess ? text : nil)
        }
        
        if(inputView == input_confirm_password) {
            presenter?.set(confirm_password: valid.isSuccess ? text : nil)
        }
        
        if let mail = presenter?.getEmail(),
           let pass = presenter?.getPassword(),
           let confirm = presenter?.getConfirmPassword() {
            if pass == confirm {
                lbl_status.isHidden = true
                btn_register.isEnabled = true
            } else {
                if inputView == input_confirm_password {
                    _ = inputView
                        .set(status: "Make sure you're typing confirm password is exact same!")
                        .set(statusColor: UINCColor.error)
                }
                btn_register.isEnabled = false
            }
        } else {
            btn_register.isEnabled = false
        }
    }
}
