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

class FeedsView: UIViewController, FeedsPresenterToView {
    var presenter: FeedsViewToPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UINCRefreshControl = UINCRefreshControl()
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FeedDefaultCell.source.nib, forCellReuseIdentifier: FeedDefaultCell.source.identifier)
        tableView.register(FeedAdmobCell.source.nib, forCellReuseIdentifier: FeedAdmobCell.source.identifier)
        
        refreshControl.setMaxHeightOfRefreshControl = 200
        refreshControl.setRefreshCircleSize = .medium
        tableView.backgroundView = refreshControl
    }
    
    func showAlert(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: nil, CancelCompletion: nil)
    }
    
    func reloadTableView() {
        tableView.reloadData()
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

extension FeedsView: FeedAdmobCellDelegate {
    func didTapRemoveAds(cell: FeedAdmobCell) {
        LeoPopScreen(on: self, delegate: self, dataSource: self)
    }
    
    func didReceivedAd(cell: FeedAdmobCell) {
        
    }
}

extension FeedsView: LeoPopScreenDelegate {
    func didTapPrimaryButton(view: LeoPopScreen) {
        view.dismiss(animated: true, completion: nil)
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
        return nil
    }
    
    var titleText: String? {
        return "Remove Ads"
    }
    
    var bodyText: String? {
        return "remove all ads"
    }
    
    var buttonPrimaryText: String? {
        return "Purchase"
    }
    
    var buttonSecondaryText: String? {
        return nil
    }
    
    var presentationStyle: UIModalPresentationStyle {
        return .fullScreen
    }
    
    var showButtonCancelAtNavBar: Bool {
        return true
    }
}
