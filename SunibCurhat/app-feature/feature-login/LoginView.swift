//
//  LoginView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 06/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

class LoginView: UIViewController, LoginPresenterToView {
    var presenter: LoginViewToPresenter?
    
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var stack_container: UIStackView!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var lbl_status: UINCLabelNote!
    @IBOutlet weak var lbl_register: UINCLabelClickable!
    @IBOutlet weak var lbl_agreement: UINCLabelClickable!
    @IBOutlet weak var btn_login: UINCButtonPrimaryRounded!
    @IBOutlet weak var btn_login_anon: UINCButtonSecondaryRounded!
    private lazy var input_email: UINCInput = UINCInput()
    private lazy var input_password: UINCInput = UINCInput()
    
    init() {
        super.init(nibName: String(describing: LoginView.self), bundle: Bundle(for: LoginView.self))
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
        let image_url = preferences?.images.image_url_login ?? ""
        image_view.image = nil
        
        if let url = URL(string: image_url) {
            image_view.kf.setImage(with: url)
        }
        
        let view_email = UIView()
        let view_password = UIView()
        
        view_email.addSubview(input_email)
        view_password.addSubview(input_password)
        
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
        
        stack_container.insertArrangedSubview(view_email, at: 1)
        stack_container.insertArrangedSubview(view_password, at: 2)
        stack_container.spacing = 16
        
        lbl_status.numberOfLines = 0
        lbl_status.changeFontSize(size: 14)
        lbl_status.textColor = UINCColor.error
        lbl_status.isHidden = true
        
        lbl_register.numberOfLines = 0
        lbl_register.textAlignment = .center
        lbl_register.text = "Don't have an account? Register"
        lbl_register.clickables["Register"] = { [weak self] in
            self?.presenter?.didClickRegister()
        }
        
        lbl_agreement.numberOfLines = 0
        lbl_agreement.textAlignment = .center
        lbl_agreement.changeFontSize(size: 12)
        lbl_agreement.text = "By clicking on the \"Login\" button, you agree to our User Agreement and our Privacy Policy"
        lbl_agreement.clickables["User Agreement"] = { [weak self] in
            self?.presenter?.didClickAgreement()
        }
        lbl_agreement.clickables["Privacy Policy"] = { [weak self] in
            self?.presenter?.didClickPrivacyPolicy()
        }
        
        btn_login.setTitle("Login", for: .normal)
        btn_login_anon.setTitle("Login As Anonymous", for: .normal)
        
        btn_login.isEnabled = false
        
        view_container.backgroundColor = UINCColor.bg_primary
        view_container.roundCorners([.topLeft, .topRight], radius: view_container.width/6)
    }
    
    func showFailLoginMessage(text: String) {
        input_email
            .set(statusColor: UINCColor.error)
            .isEnabled = true
        input_password
            .set(statusColor: UINCColor.error)
            .isEnabled = true
        
        lbl_register.isUserInteractionEnabled = true
        lbl_agreement.isUserInteractionEnabled = true
        
        lbl_status.isHidden = false
        lbl_status.text = text
    }
    
    func startLoader(isFromAnon: Bool) {
        input_email.isEnabled = false
        input_password.isEnabled = false
        lbl_register.isUserInteractionEnabled = false
        lbl_agreement.isUserInteractionEnabled = false
        if isFromAnon  {
            btn_login_anon.startAnimate()
        } else {
            btn_login.startAnimate()
        }
    }
    
    func stopLoader(isSuccess: Bool, isFromAnon: Bool, completion: (() -> Void)?) {
        if isSuccess {
            if isFromAnon {
                btn_login_anon.stopAnimate(style: .expand, refertAfterDelay: 1) {
                    completion?()
                }
            } else {
                btn_login.stopAnimate(style: .expand, refertAfterDelay: 1) {
                    completion?()
                }
            }
        } else {
            if isFromAnon {
                btn_login_anon.stopAnimate(style: .shake)
            } else {
                btn_login.stopAnimate(style: .shake)
            }
        }
    }
    
    @IBAction func didClickLogin(_ sender: Any) {
        presenter?.didClickLogin()
        
    }
    
    @IBAction func didClickLoginAsAnonymous(_ sender: Any) {
        presenter?.didClickLoginAsAnonymous()
    }
}

extension LoginView: UINCInputDelegate {
    func didGetInput(inputView: UINCInput, text: String, valid: ValidationResult) {
        if(inputView == input_email) {
            presenter?.set(email: valid.isSuccess ? text : nil)
        }
        
        if(inputView == input_password) {
            presenter?.set(password: valid.isSuccess ? text : nil)
        }
        
        if let _ = presenter?.getEmail(), let _ = presenter?.getPassword() {
            lbl_status.isHidden = true
            btn_login.isEnabled = true
        } else {
            btn_login.isEnabled = false
        }
    }
}
