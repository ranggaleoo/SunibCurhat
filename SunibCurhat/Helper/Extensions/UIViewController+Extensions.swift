import UIKit

extension UIViewController {
    
    static var alertActions: [String: (UIAlertAction) -> Void] = [:]
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
    
    func setupMenuBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bar_btn_more_vert"), style: .plain, target: self, action: #selector(actionMenuBarButtonItem))
    }
    
    @objc private func actionMenuBarButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Privacy Police", style: .default, handler: { (act) in
            guard let url_privacy = URL(string: "https://bit.ly/privacypolicesunib") else {return}
            if UIApplication.shared.canOpenURL(url_privacy) {
                UIApplication.shared.open(url_privacy, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- open privacy police")
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "User Agreement", style: .default, handler: { (act) in
            guard let url_eula = URL(string: "https://bit.ly/uelasunibcurhat") else {return}
            if UIApplication.shared.canOpenURL(url_eula) {
                UIApplication.shared.open(url_eula, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- user agreement")
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupMoreBarButtonItem(handler: @escaping (UIAlertAction) -> Void) {
        UIViewController.alertActions["more_bar_button_item"] = handler
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bar_btn_more_vert"), style: .plain, target: self, action: #selector(actionMoreBarButtonItem(_:)))
    }
    
    @objc private func actionMoreBarButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        guard let action = UIViewController.alertActions["more_bar_button_item"] else { return }
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: action))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, OKcompletion: ((UIAlertAction) -> Void)?, CancelCompletion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setTitle(font: UIFont.custom.bold.size(of: 15), color: UIColor.custom.black_absolute)
        alert.setMessage(font: UIFont.custom.regular.size(of: 12), color: UIColor.custom.gray_absolute)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: OKcompletion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: CancelCompletion))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoaderIndicator() {
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            activityIndicator.center = self.view.center
        }
    }
    
    func dismissLoaderIndicator() {
        DispatchQueue.main.async {
            self.view.subviews.flatMap {  $0 as? UIActivityIndicatorView }.forEach {
                $0.backgroundColor = .clear
                $0.removeFromSuperview()
            }
        }
    }
    
    func endEditing() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewEndEditting)))
    }
    
    @objc private func viewEndEditting() {
        self.view.endEditing(true)
    }
}
