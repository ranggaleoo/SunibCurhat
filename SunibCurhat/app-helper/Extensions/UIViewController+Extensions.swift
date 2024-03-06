import UIKit

extension UIViewController {
    
    static var alertActions: [String: (UIAlertAction) -> Void] = [:]
    
    public func navigationDefault() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.backgroundColor = UINCColor.bg_primary
        self.navigationController?.navigationBar.tintColor  = UINCColor.primary
    }
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
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
        alert.setTitle(font: UIFont.custom.bold.size(of: 15), color: UIColor.label)
        alert.setMessage(font: UIFont.custom.regular.size(of: 12), color: UIColor.label)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: OKcompletion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: CancelCompletion))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoaderIndicator() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
                activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                activityIndicator.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
                activityIndicator.startAnimating()
                
                window.addSubview(activityIndicator)
                activityIndicator.center = window.center
            }
        }
    }
    
    func dismissLoaderIndicator() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                window.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach {
                    $0.backgroundColor = .clear
                    $0.removeFromSuperview()
                }
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
