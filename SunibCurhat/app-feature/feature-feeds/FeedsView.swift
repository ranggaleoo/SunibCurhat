//
//  FeedsView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import LeoPopScreen
import SPPermissions
import MessageUI

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
        SPPermission.Dialog.requestIfNeeded(with: [.notification, .camera, .photoLibrary, .contacts], on: self, delegate: self, dataSource: self)
        storeKit.delegate = self
        
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
        title = "Timeline"
        var image_add_thread: UIImage?
        if #available(iOS 13.0, *) {
            image_add_thread = UIImage(symbol: .plus_bubble_fill, configuration: nil)
        } else {
            image_add_thread = UIImage(named: "bar_btn_add_thread")
        }
        
        let buttonAddThread = UIBarButtonItem(image: image_add_thread, style: .plain, target: self, action: #selector(toAddThread))
        let buttonBarMenu = UIBarButtonItem(image: UIImage(named: "bar_btn_more_vert"), style: .plain, target: self, action: #selector(actionMenuBarButtonItem))
        navigationItem.rightBarButtonItems = [buttonBarMenu, buttonAddThread]
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
    
    func moveFromAddThread() {
        presenter?.requestGetTimeline(resetData: true)
    }
    
    @objc private func toAddThread() {
        let storyboad = UIStoryboard(name: "AddThread", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "add_thread")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func actionMenuBarButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
//        alert.addAction(UIAlertAction(title: "Premium", style: .default, handler: { (act) in
//            self.performSegue(withIdentifier: "toPayment", sender: self)
//        }))
        
        alert.addAction(UIAlertAction(title: "Contact Us", style: .default, handler: { (act) in
            let alert2 = UIAlertController(title: "Contact Us", message: nil, preferredStyle: .actionSheet)
            
            alert2.addAction(UIAlertAction(title: "Email", style: .default, handler: { (act) in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([ConstGlobal.contact_email ?? "noreplyhere@hi2.in"])
                    mail.setSubject(ConstGlobal.app_name ?? "Subject")
                    mail.setMessageBody("<p>Hi \(ConstGlobal.app_name ?? "")</p>", isHTML: true)
                    
                    self.present(mail, animated: true)
                } else {
                    // show failure alert
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { (act) in
                guard let url = URL(string: "https://www.instagram.com/\(ConstGlobal.contact_instagram ?? "instagram")/") else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if success {
                            print("----- open instagram")
                        }
                    })
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Whatsapp", style: .default, handler: { (act) in
                guard let url = URL(string: "https://api.whatsapp.com/send?phone=\(ConstGlobal.contact_whatsapp ?? "")&text=Halo%20\(ConstGlobal.app_name ?? "")") else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if success {
                            print("----- open whatsapp")
                        }
                    })
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert2, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: .default, handler: { (act) in
            guard let url_privacy = URL(string: "https://bit.ly/privacypolicesunib") else {return}
            if UIApplication.shared.canOpenURL(url_privacy) {
                UIApplication.shared.open(url_privacy, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- open privacy policy")
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
        
    }
    
    func didTapMore(cell: FeedDefaultCell) {
        
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
            _ = LeoPopScreen(on: self, delegate: self, dataSource: self)
        }
    }
    
    func didFetchInvalidProduct(store: LeoStoreKit, product: [LeoStoreKitProduct.Identifier?]) {
        DispatchQueue.main.async {
            self.dismissLoaderIndicator()
        }
        debugPrint(product)
    }
    
    func failFetchProduct(store: LeoStoreKit) {
        DispatchQueue.main.async {
            self.dismissLoaderIndicator()
        }
        debugPrint("FAILED")
    }
    
    func didBuyProduct(store: LeoStoreKit) {
        debugPrint(#function)
        UDHelpers.shared.set(value: true, key: .isFreeAds)
        dismiss(animated: true, completion: nil)
    }
    
    func failBuyProduct(store: LeoStoreKit) {
        debugPrint(#function)
    }
    
    func onBuyProcessing(store: LeoStoreKit) {
        debugPrint(#function)
    }
}

extension FeedsView: LeoPopScreenDelegate {
    func didTapPrimaryButton(view: LeoPopScreen) {
        storeKit.buy(identifier: product?.id ?? .example)
    }
    
    func didTapSecondaryButton(view: LeoPopScreen) {
        view.dismiss(animated: true, completion: nil)
    }
    
    func didCancel(view: LeoPopScreen) {
        view.dismiss(animated: true, completion: nil)
    }
}

extension FeedsView: LeoPopScreenDataSource {
    var image: UIImage? {
        return UIImage(identifierName: .image_super_thankyou)
    }
    
    var titleText: String? {
        return product?.title
    }
    
    var bodyText: String? {
        return product?.desc
    }
    
    var buttonPrimaryText: String? {
        return "Remove for " + (product?.currencySymbol ?? "") + (String(describing: product?.price ?? 0.00))
    }
    
    var buttonSecondaryText: String? {
        return "Cancel"
    }
    
    var presentationStyle: UIModalPresentationStyle {
        return .popover
    }
    
    var buttonPrimaryColor: UIColor {
        return UIColor.custom.blue
    }
}

extension FeedsView: SPPermissionDialogDelegate {}

extension FeedsView: SPPermissionDialogDataSource {
    func description(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera            : return UIApplication.shared.infoPlist(key: .NSCameraUsageDescription)
        case .photoLibrary      : return UIApplication.shared.infoPlist(key: .NSPhotoLibraryUsageDescription)
        case .contacts          : return UIApplication.shared.infoPlist(key: .NSContactsUsageDescription)
        default: return "Need Allow for use this Application"
        }
    }
}

extension FeedsView: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let e = error {
            print(e.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
