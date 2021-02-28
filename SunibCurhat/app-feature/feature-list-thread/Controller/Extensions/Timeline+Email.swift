//
//  Timeline+Email.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 21/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import MessageUI

extension ListCurhatViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let e = error {
            debugLog(e.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
