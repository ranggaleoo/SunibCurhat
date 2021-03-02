//
//  UINCSwitchDefault.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

class UINCSwitchDefault: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        tintColor = UINCColor.brandColor()
    }
}
