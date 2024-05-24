//
//  FeedsView+CoachMarksController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 22/05/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Instructions

enum CoachMarksItem: Int, CaseIterable {
//    case newThreadButton = 0
    case profileButton = 0
    case chatListNavigationBarButton = 1
    case moreOnFeedButton = 2
//    case sendChatButton = 4
    
    func getDescription() -> String {
        switch self {
//        case .newThreadButton:
//            return "create new post thread"
        case .profileButton:
            return "Here is the button go to the profile page, where you can review all your informations."
        case .chatListNavigationBarButton:
            return "chit chat list with your friends"
        case .moreOnFeedButton:
            return "more action for you, including starting to chat!"
        default:
            return "hai"
        }
    }
}

extension FeedsView: CoachMarksControllerDataSource {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        CoachMarksItem.allCases.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        if let markItem = CoachMarksItem(rawValue: index) {
            switch markItem {
//            case .newThreadButton:
//                guard let a = self.navigationController.tabba
//                return coachMarksController.helper.makeCoachMark(for: buttonAddThread.customView)
            case .profileButton:
                return coachMarksController.helper.makeCoachMark(for: buttonProfile.customView)
            case .chatListNavigationBarButton:
                guard let tabbarView = self.tabBarController?.tabBar.subviews.last
                else { return coachMarksController.helper.makeCoachMark() }
                
                return coachMarksController.helper.makeCoachMark(for: tabbarView)
            case .moreOnFeedButton:
                guard let cell = self.tableView.visibleCells.randomItem as? FeedDefaultCell
                else { return coachMarksController.helper.makeCoachMark() }
                
                return coachMarksController.helper.makeCoachMark(for: cell.btn_more)
            }
        }
        
        return coachMarksController.helper.makeCoachMark()
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        if let markItem = CoachMarksItem(rawValue: index) {
            let coachView = coachMarksController.helper.makeDefaultCoachViews(
                withArrow: true,
                arrowOrientation: coachMark.arrowOrientation,
                hintText: markItem.getDescription(),
                nextText: "Ok!",
                nextLabelPosition: .bottomTrailing
            )
            coachView.arrowView?.background.innerColor = UINCColor.primary
            coachView.arrowView?.background.borderColor = UINCColor.primary
            coachView.bodyView.background.innerColor = UINCColor.primary
            coachView.bodyView.background.borderColor = UINCColor.primary
            coachView.bodyView.hintLabel.textColor = UINCColor.primary_foreground
            coachView.bodyView.nextLabel.textColor = UINCColor.primary_foreground
            coachView.bodyView.nextLabel.font = UIFont.boldSystemFont(ofSize: 16)
            
            return (bodyView: coachView.bodyView, arrowView: coachView.arrowView)
        }
        let defaultView = coachMarksController.helper.makeDefaultCoachViews()
        return (bodyView: defaultView.bodyView, arrowView: defaultView.arrowView)
    }
}

extension FeedsView: CoachMarksControllerDelegate {
    func shouldHandleOverlayTap(in coachMarksController: CoachMarksController, at index: Int) -> Bool {
        presenter?.shouldHandleOverlayCoachMarksTap()
        return true
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didEndShowingBySkipping skipped: Bool) {
        debugLog("didEndShowingBySkipping coachmaek")
        presenter?.didEndInstructions()
    }
}
