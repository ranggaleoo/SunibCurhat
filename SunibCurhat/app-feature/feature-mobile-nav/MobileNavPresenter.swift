//
//  MobileNavPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class MobileNavPresenter: MobileNavViewToPresenter {
    weak var view: MobileNavPresenterToView?
    var interactor: MobileNavPresenterToInteractor?
    var router: MobileNavPresenterToRouter?
    
    private var sections: [MobileNavigationPageSection]?
    private var tmpItemAction: MobileNavigationPageItem?
    
    required init(sections: [MobileNavigationPageSection]?) {
        self.sections = sections
    }
    
    func didLoad() {
        view?.setupViews()
    }
    
    func didConfirm() {
        view?.startLoader()
        switch tmpItemAction?.content {
        case .string(value: let stringValue):
            interactor?.hitActionApi(path: stringValue)
        default:
            debugLog("tmpitemaction \(String(describing: tmpItemAction?.content))")
        }
    }
    
    func didSwitch(isOn: Bool, indexPath: IndexPath) {
        var item = sections?.item(at: indexPath.section)?.items?.item(at: indexPath.row)
        item?.content = .bool(value: isOn)
        item?.after_action?.run(item, { [weak self] (success) in
            debugLog(item)
        })
    }
    
    func numberOfSections() -> Int? {
        return sections?.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int? {
        return sections?.item(at: section)?.items?.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> MobileNavigationPageSection? {
        return sections?.item(at: indexPath.section)
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        return sections?.item(at: section)?.title
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let sectionSelected = sections?.item(at: indexPath.section)
        let itemSelected = sectionSelected?.items?.item(at: indexPath.row)
        switch itemSelected?.type {
        case .sub_menu:
            switch itemSelected?.content {
            case .sections(value: let sections):
                router?.navigateToMobileNav(from: view, data: sections)
            default:
                debugLog("sub menu but not sections \(String(describing: itemSelected?.content))")
            }
        case .open_url:
            switch itemSelected?.content {
            case .url(let url):
                router?.navigateToExternalURL(url: url)
            case .string(value: let stringValue):
                if let urlString = URL(string: stringValue) {
                    router?.navigateToExternalURL(url: urlString)
                }
            default:
                debugLog("open url but not url \(String(describing: itemSelected?.content))")
            }
        case .web_view:
            switch itemSelected?.content {
            case .url(let url):
                router?.navigateToWebView(from: view, url: url)
            default:
                debugLog("webview url but not url \(String(describing: itemSelected?.content))")
            }
        case .action_api:
            switch itemSelected?.content {
            case .string(value: _):
                self.tmpItemAction = itemSelected
                view?.showConfirmation(title: "Confirmation", message: itemSelected?.description ?? "")
            default:
                debugLog("hit api \(String(describing: itemSelected?.content))")
            }
        default:
            debugLog(sectionSelected ?? "")
        }
    }
}

extension MobileNavPresenter: MobileNavInteractorToPresenter {
    func didHitActionApi() {
        view?.stopLoader()
        tmpItemAction?.after_action?.run()
    }
    
    func failHitActionApi(message: String) {
        view?.stopLoader()
        view?.showMessage(title: "Oops", message: message)
    }
}
