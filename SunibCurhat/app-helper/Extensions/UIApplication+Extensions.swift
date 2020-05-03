import UIKit

extension UIApplication {
    
    func replaceRootViewController(controller: UIViewController) {
        self.keyWindow?.rootViewController = controller
    }
    
    func infoPlist(key: Identifier.infoPlist) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
    }
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}
