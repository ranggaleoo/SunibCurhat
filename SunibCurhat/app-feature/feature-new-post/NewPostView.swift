//
//  NewPostView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation

class NewPostView: UIViewController, NewPostPresenterToView {
    var presenter: NewPostViewToPresenter?
    
    @IBOutlet private weak var stack_container: UIStackView!
    @IBOutlet private weak var btn_post: UINCButtonPrimaryRounded!
    private lazy var input_post: UINCInputArea = UINCInputArea()
    
    init() {
        super.init(nibName: String(describing: NewPostView.self), bundle: Bundle(for: NewPostView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        title = "New Post"
        view.backgroundColor = UINCColor.bg_primary
        let view_input = UIView()
        
        view_input.addSubview(input_post)
        
        input_post
            .hideLabel()
            .set(placeholder: "Mau curhat apa?")
            .add(validation: .isNotBlank)
            .add(validation: .isGreaterThanOrEqual(number: 3))
            .left(to: view_input.leftAnchor, 16)
            .right(to: view_input.rightAnchor, 16)
            .top(to: view_input.topAnchor, 16)
            .bottom(to: view_input.bottomAnchor)
            .delegate = self
        
        btn_post.isEnabled = false
        btn_post.setTitle("Post", for: .normal)
        
        stack_container.insertArrangedSubview(view_input, at: 0)
        stack_container.spacing = 16
    }
    
    func startLoader() {
        btn_post.startAnimate()
        self.showLoaderIndicator()
    }
    
    func stopLoader() {
        btn_post.stopAnimate()
        self.dismissLoaderIndicator()
    }
    
    func showFailMessagePost(message: String) {
        _ = input_post
            .set(status: message)
            .set(statusColor: UINCColor.error)
    }
    
    @IBAction func didClickPost(_ sender: Any?) {
        presenter?.didClickPost()
    }
}

extension NewPostView: UINCInputAreaDelegate {
    func didGetInput(inputAreaView: UINCInputArea, text: String, valid: ValidationResult) {
        if valid.isSuccess {
            presenter?.set(textContent: text)
            btn_post.isEnabled = true
        } else {
            btn_post.isEnabled = false
        }
    }
}
