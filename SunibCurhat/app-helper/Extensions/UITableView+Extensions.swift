//
//  UITableView+Extensions.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit

extension UITableView {
    func setViewForEmptyData(image: UIImage?, message: String?) {
        let container: UIView = {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            return v
        }()
        
        if let i = image {
            let img: UIImageView = {
                let img = UIImageView(frame: CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height))
                img.image = i
                img.sizeToFit()
                return img
            }()
            
            container.addSubview(img)
            img.center = container.center
            
            if let m = message {
                let lbl: UILabel = {
                    let l = UILabel(frame: CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height))
                    l.text = m
                    l.numberOfLines = 0
                    l.textAlignment = .center
                    l.font = UIFont.custom.regular.size(of: 12)
                    l.sizeToFit()
                    return l
                }()
                
                container.addSubview(lbl)
                lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 16).isActive = true
                lbl.centerXAnchor.constraint(equalTo: img.centerXAnchor).isActive = true
            }
        }
        
        self.backgroundView = container
    }
}
