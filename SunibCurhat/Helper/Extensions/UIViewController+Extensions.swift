import UIKit

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
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
}
