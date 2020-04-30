//
//  UIFont+Extensions.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    enum custom {
        case bold, regular
        
        func size(of: CGFloat) -> UIFont {
            switch self {
            case .bold      : return UIFont.boldSystemFont(ofSize: of)
            case .regular   : return UIFont.systemFont(ofSize: of)
            }
        }
    }
}


