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
    @IBOutlet weak var btn_login: UINCButtonPrimaryRounded!
    @IBOutlet weak var btn_login_anon: UINCButtonSecondaryRounded!
    private lazy var input_email: UINCInput = UINCInput()
    private lazy var input_password: UINCInput = UINCInput()
    
    private var email: String?
    private var password: String?
    
    init() {
        super.init(nibName: String(describing: LoginView.self), bundle: Bundle(for: LoginView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        image_view.backgroundColor = UINCColor.bg_secondary
        image_view.contentMode = .scaleAspectFill
        image_view.clipsToBounds = true
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        let image_url = preferences?.images.image_url_login ?? ""
        image_view.image = nil
        
        if let url = URL(string: image_url) {
            image_view.kf.setImage(with: url)
        }
        
        view_container.backgroundColor = UINCColor.bg_primary
        view_container.roundCorners([.topLeft, .topRight], radius: view_container.width/6)
        
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
        
        lbl_status.isHidden = true
        lbl_register.textAlignment = .center
        lbl_register.text = "Don't have an account? Register"
        lbl_register.clickables["Register"] = { [weak self] in
            self?.presenter?.navigateToRegister()
        }
        
        btn_login.setTitle("Login", for: .normal)
        btn_login_anon.setTitle("Login As Anonymous", for: .normal)
        
        btn_login.isEnabled = false
    }
}

extension LoginView: UINCInputDelegate {
    func didGetInput(inputView: UINCInput, text: String, valid: ValidationResult) {
        if(inputView == input_email) {
            email = valid.isSuccess ? text : nil
        }
        
        if(inputView == input_password) {
            password = valid.isSuccess ? text : nil
        }
        
        if let mail = email, let pass = password {
            btn_login.isEnabled = true
        } else {
            btn_login.isEnabled = false
        }
    }
}
