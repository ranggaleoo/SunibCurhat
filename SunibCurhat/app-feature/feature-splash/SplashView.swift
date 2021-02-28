//
//  SplashView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation

class SplashView: UIViewController, SplashPresenterToView {
    var presenter: SplashViewToPresenter?
    
    @IBOutlet weak var image_icon: UIImageView!
    
    init() {
        super.init(nibName: String(describing: SplashView.self), bundle: Bundle(for: SplashView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.custom.blue
        image_icon.image = UIImage(identifierName: .image_logo)
    }
    
    func startLoader() {
        debugLog(#function)
    }
    
    func stopLoader() {
        debugLog(#function)
    }
    
    func showAlertConfirm(title: String, message: String, okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        super.showAlert(title: title, message: message) { (_) in
            okCompletion?()
        } CancelCompletion: { (_) in
            cancelCompletion?()
        }
    }
}
