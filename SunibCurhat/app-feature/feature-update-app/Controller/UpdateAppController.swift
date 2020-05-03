//
//  UpdateAppController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit
import Siren

class UpdateAppController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionUpdate(_ sender: UINCButtonPrimaryRounded) {
        Siren.shared.launchAppStore()
    }
}
