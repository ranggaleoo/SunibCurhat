//
//  FeedsView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import SPPermissions
import MessageUI
import Kingfisher

class FeedsView: UIViewController, FeedsPresenterToView {
    var presenter: FeedsViewToPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UINCRefreshControl = UINCRefreshControl()
    private var storeKit = LeoStoreKit()
    private var product: LeoStoreKitProduct?
    
    init() {
        super.init(nibName: String(describing: FeedsView.self), bundle: Bundle(for: FeedsView.self))
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
        requestPermission()
        storeKit.delegate = self
        
        tableView.backgroundColor = UINCColor.bg_primary
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FeedDefaultCell.source.nib, forCellReuseIdentifier: FeedDefaultCell.source.identifier)
        tableView.register(FeedAdmobCell.source.nib, forCellReuseIdentifier: FeedAdmobCell.source.identifier)
        
        refreshControl.setMaxHeightOfRefreshControl = 200
        refreshControl.setRefreshCircleSize = .medium
        refreshControl.setFillColor = UIColor.custom.blue
        tableView.backgroundView = refreshControl
        
        refreshControl.setOnRefreshing = { [weak self] in
            self?.presenter?.requestGetTimeline(resetData: true)
        }
        
        navigationDefault()
        title = "Home"
        let buttonAddThread = UIBarButtonItem(
            image: UIImage(symbol: .SquareAndPencil, configuration: .init(weight: .bold))?
                .withTintColor(UINCColor.primary, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(toAddThread)
        )
        let buttonBarMenu = UIBarButtonItem(
            image: UIImage(symbol: .EllipsisCircleFill),
            style: .plain,
            target: self,
            action: #selector(actionMenuBarButtonItem)
        )

        let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        avatarImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 20 // Half of the desired avatar image view's width
        avatarImageView.kf.setImage(with: URL(string: presenter?.getUser()?.avatar ?? ""))
        
        let buttonProfile = UIBarButtonItem(customView: avatarImageView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonProfileHandler))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        navigationItem.rightBarButtonItems = [buttonProfile, buttonAddThread]
    }
    
    func showAlert(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: nil, CancelCompletion: nil)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func finishRefershControl() {
        if refreshControl.isRefreshing() {
            refreshControl.endRefreshing()
        }
    }
    
    func updateLikeCell(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeedDefaultCell {
            cell.btn_like.isEnabled = true
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func showShareController(items: [Any], completion: @escaping (() -> Void)) {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        vc.completionWithItemsHandler = { (actType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
            if completed {
                completion()
            }
        }
        self.present(vc, animated: true)
    }
    
    func removeCell(index: [IndexPath]) {
        tableView.deleteRows(at: index, with: .left)
    }
    
    func moveFromAddThread() {
        presenter?.requestGetTimeline(resetData: true)
    }
    
    func requestPermission() {
        let timesPermission = UDHelpers.shared.getInt(key: .counterRequestPermission)
        debugLog("time permission", timesPermission)
        
        if timesPermission == ConstGlobal.TIMES_REQUEST_PERMISSION || timesPermission == 0 {
            SPPermissions.dialog([.notification, .camera, .photoLibrary]).show(self, sender: self)
            UDHelpers.shared.set(value: 1, key: .counterRequestPermission)
        
        } else {
            UDHelpers.shared.set(value: timesPermission + 1, key: .counterRequestPermission)
        }
    }
    
    @objc private func buttonProfileHandler() {
        presenter?.didClickProfile()
    }
    
    @objc private func toAddThread() {
        presenter?.didClickNewPost()
//        let storyboad = UIStoryboard(name: "AddThread", bundle: nil)
//        let vc = storyboad.instantiateViewController(withIdentifier: "add_thread")
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func actionMenuBarButtonItem(_ sender: UIBarButtonItem) {
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
//        alert.addAction(UIAlertAction(title: "Premium", style: .default, handler: { (act) in
//            self.performSegue(withIdentifier: "toPayment", sender: self)
//        }))
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { [weak self] (_) in
            let settingVC = SettingsRouter.createSettingsModule()
            self?.navigationController?.pushViewController(settingVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Contact Us", style: .default, handler: { (act) in
            let alert2 = UIAlertController(title: "Contact Us", message: nil, preferredStyle: .actionSheet)
            
            alert2.addAction(UIAlertAction(title: "Email", style: .default, handler: { (act) in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([preferences?.contacts?.email ?? "businesssakti@gmail.com"])
                    mail.setSubject(preferences?.app_name ?? "Subject")
                    mail.setMessageBody("<p>Hi \(preferences?.app_name ?? "")</p>", isHTML: true)
                    
                    self.present(mail, animated: true)
                } else {
                    // show failure alert
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { (act) in
                guard let url = URL(string: "https://www.instagram.com/\(preferences?.contacts?.instagram ?? "instagram")/") else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if success {
                            debugLog("----- open instagram")
                        }
                    })
                }
            }))
            
//            alert2.addAction(UIAlertAction(title: "Whatsapp", style: .default, handler: { (act) in
//                guard let url = URL(string: "https://api.whatsapp.com/send?phone=\(ConstGlobal.contact_whatsapp ?? "")&text=Halo%20\(ConstGlobal.app_name ?? "")") else {return}
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
//                        if success {
//                            debugLog("----- open whatsapp")
//                        }
//                    })
//                }
//            }))
            
            alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert2, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: .default, handler: { [weak self] (act) in
            self?.presenter?.didClickPrivacy()
        }))
        
        alert.addAction(UIAlertAction(title: "User Agreement", style: .default, handler: { [weak self] (act) in
            self?.presenter?.didClickAgreement()
        }))
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { [weak self] (act) in
            self?.presenter?.didClickSignOut()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FeedsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeline = presenter?.cellForRowAt(indexPath: indexPath)
        
        if timeline?.is_ads ?? false, let cell = tableView.dequeueReusableCell(withIdentifier: FeedAdmobCell.source.identifier) as? FeedAdmobCell {
            cell.timeline = timeline
            cell.root = self
            cell.delegate = self
            return cell
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: FeedDefaultCell.source.identifier) as? FeedDefaultCell {
            cell.timeline = timeline
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            presenter?.scrollViewDidScroll()
        }
    }
}

extension FeedsView: FeedDefaultCellDelegate {
    func didTapLike(cell: FeedDefaultCell) {
        if let index = tableView.indexPath(for: cell) {
            presenter?.requestLike(indexPath: index, isLiked: cell.isLiked)
            let liked = !cell.isLiked
            cell.isLiked = liked
            cell.btn_like.isEnabled = false
        }
    }
    
    func didTapComment(cell: FeedDefaultCell) {
        if let index = tableView.indexPath(for: cell) {
            presenter?.requestComment(indexPath: index)
        }
    }
    
    func didTapShare(cell: FeedDefaultCell) {
        if let index = tableView.indexPath(for: cell) {
            presenter?.requestShare(indexPath: index)
        }
    }
    
    func didTapMore(cell: FeedDefaultCell) {
        if let index = tableView.indexPath(for: cell) {
            if let timelineItem = presenter?.getTimelineItem(indexPath: index) {
                
                let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
                if let user_id = presenter?.getUser()?.user_id, user_id == timelineItem.user_id {
                    alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (act) in
                        self.presenter?.requestDeleteTimeline(indexPath: index)
                    }))
                
                } else if let user_id = presenter?.getUser()?.user_id, user_id != timelineItem.user_id {
//                    alert.addAction(UIAlertAction(title: "Send Chat", style: .default, handler: { [weak self] (act) in
//                        self?.presenter?.didClickSendChat(to: timelineItem.user_id)
//                        if let vc = self.tabBarController?.viewControllers {
//                            guard let navigationController = vc[1] as? UINavigationController else { return }
//                            if let c = navigationController.topViewController as? ChatsViewController {
//                                let myDeviceId          = RepoMemory.device_id
//                                let strangerDeviceId    = timelineItem.device_id
//                                
//                                self.tabBarController?.selectedIndex = 1
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                                    let chat_id = myDeviceId + "+" + strangerDeviceId
//                                    let name = timelineItem.name
//                                    let users = [myDeviceId, strangerDeviceId]
//                                    c.createChatRoom(chat_id: chat_id, name: name, users: users)
//                                })
//                            }
//                        }
//                    }))
                    
                    alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (act) in
                        self.presenter?.requestReport(indexPath: index)
                    }))
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension FeedsView: FeedAdmobCellDelegate {
    func didTapRemoveAds(cell: FeedAdmobCell) {
        showLoaderIndicator()
        storeKit.fetchProducts()
    }
    
    func didReceivedAd(cell: FeedAdmobCell) {
        
    }
}

extension FeedsView: LeoStoreKitDelegate {
    func didFetchProduct(store: LeoStoreKit, product: [LeoStoreKitProduct]) {
        self.product = store.get(product: .removeads)
        DispatchQueue.main.async {
            self.dismissLoaderIndicator()
        }
    }
    
    func didFetchInvalidProduct(store: LeoStoreKit, product: [LeoStoreKitProduct.Identifier?]) {
        DispatchQueue.main.async {
            self.dismissLoaderIndicator()
        }
        debugLog(product)
    }
    
    func failFetchProduct(store: LeoStoreKit) {
        DispatchQueue.main.async {
            self.dismissLoaderIndicator()
        }
        debugLog("FAILED")
    }
    
    func didBuyProduct(store: LeoStoreKit) {
        debugLog(#function)
        UDHelpers.shared.set(value: true, key: .isFreeAds)
        dismiss(animated: true, completion: nil)
    }
    
    func failBuyProduct(store: LeoStoreKit) {
        debugLog(#function)
    }
    
    func onBuyProcessing(store: LeoStoreKit) {
        debugLog(#function)
    }
}

//extension FeedsView: SPPermissionDialogDelegate {}
//
//extension FeedsView: SPPermissionDialogDataSource {
//    func description(for permission: SPPermissionType) -> String? {
//        switch permission {
//        case .camera            : return UIApplication.shared.infoPlist(key: .NSCameraUsageDescription)
//        case .photoLibrary      : return UIApplication.shared.infoPlist(key: .NSPhotoLibraryUsageDescription)
////        case .contacts          : return UIApplication.shared.infoPlist(key: .NSContactsUsageDescription)
//        default: return "Need Allow for use this Application"
//        }
//    }
//    
//    var showCloseButton: Bool {
//        true
//    }
//}

extension FeedsView: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let e = error {
            debugLog(e.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
