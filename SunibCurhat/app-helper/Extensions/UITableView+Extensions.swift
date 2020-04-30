//
//  UITableView+Extensions.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func setViewForEmptyData(image: UIImage?, message: String?) {
        let container: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            return v
        }()
        
        if let m = message {
            let lbl: UILabel = {
                let l = UILabel(frame: CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height))
                l.text = m
                l.textColor = UIColor.custom.black_absolute
                l.numberOfLines = 0
                l.textAlignment = .center
                l.font = UIFont.custom.regular.size(of: 12)
                l.sizeToFit()
                return l
            }()
            
            container.addSubview(lbl)
            lbl.center = container.center
            
            if let i = image {
                let img: UIImageView = {
                    let img = UIImageView(frame: CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height))
                    img.image = i
                    img.sizeToFit()
                    return img
                }()
                
                container.addSubview(img)
                img.translatesAutoresizingMaskIntoConstraints = false
                img.bottomAnchor.constraint(equalTo: lbl.topAnchor, constant: -16).isActive = true
                img.centerXAnchor.constraint(equalTo: lbl.centerXAnchor).isActive = true
                img.heightAnchor.constraint(equalToConstant: container.bounds.width / 3).isActive = true
                img.widthAnchor.constraint(equalToConstant: container.bounds.height / 3).isActive = true
            }
        }
        
        self.backgroundView = container
    }
}
