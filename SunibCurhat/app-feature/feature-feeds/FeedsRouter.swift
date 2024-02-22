// 
//  FeedsRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class FeedsRouter: FeedsPresenterToRouter {
    
    static func createFeedsModule() -> UIViewController {
        let view: UIViewController & FeedsPresenterToView = FeedsView()
        let presenter: FeedsViewToPresenter & FeedsInteractorToPresenter = FeedsPresenter()
        let interactor: FeedsPresenterToInteractor = FeedsInteractor()
        let router: FeedsPresenterToRouter = FeedsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToNewPost(from: FeedsPresenterToView?) {
        if let view = from as? UIViewController {
            let newPost = NewPostRouter.createNewPostModule()
            newPost.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(newPost, animated: true)
        }
    }
    
    func navigateToComment(timeline: TimelineItems, view: FeedsPresenterToView?) {
        if let vc = view as? UIViewController {
            let comment = CommentRouter.createCommentModule(timeline_id: timeline.timeline_id)
            comment.hidesBottomBarWhenPushed = true
            vc.navigationController?.pushViewController(comment, animated: true)
        }
//        if let controller = view as? UIViewController {
//            let storyboad = UIStoryboard(name: "CommentCurhat", bundle: nil)
//            if let vc = storyboad.instantiateViewController(withIdentifier: "comment") as? CommentCurhatViewController {
//                vc.timeline = timeline
//                controller.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
    
    func navigateToReport(timeline: TimelineItems, view: FeedsPresenterToView?) {
        if let controller = view as? UIViewController {
            let storyboad = UIStoryboard(name: "Report", bundle: nil)
            if let vc = storyboad.instantiateViewController(withIdentifier: "view_report") as? ReportViewController {
                vc.timeline = timeline
                controller.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func navigateToPrivacy(from: FeedsPresenterToView?, url: String?) {
        if let view = from as? UIViewController,
           let urlString = url {
            let webView = WKWebViewController()
            view.present(webView, animated: true) {
                webView.loadWebView(url: urlString, params: nil)
            }
        }
    }
    
    func naviggateToAgreement(from: FeedsPresenterToView?, url: String?) {
        if let view = from as? UIViewController,
           let urlString = url {
            let webView = WKWebViewController()
            view.present(webView, animated: true) {
                webView.loadWebView(url: urlString, params: nil)
            }
        }
    }
}
