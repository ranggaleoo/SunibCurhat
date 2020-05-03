//
//  CoronaCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class CoronaCell: UITableViewCell {
    @IBOutlet weak var lbl_name         : UINCLabelBody!
    @IBOutlet weak var lbl_positif      : UINCLabelTitle!
    @IBOutlet weak var lbl_sembuh       : UINCLabelTitle!
    @IBOutlet weak var lbl_meninggal    : UINCLabelTitle!
    
    var data: CovidDataItem? {
        didSet {
            updateUI()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI() {
        lbl_name.text       = data?.Provinsi
        lbl_positif.text    = "Positive \(data?.Kasus_Posi ?? 0)"
        lbl_sembuh.text     = "Recovered \(data?.Kasus_Semb ?? 0)"
        lbl_meninggal.text  = "Deaths \(data?.Kasus_Meni ?? 0)"
        
        lbl_positif.textColor   = UIColor.custom.red_absolute
        lbl_sembuh.textColor    = UIColor.custom.blue_absolute
        lbl_meninggal.textColor = UIColor.custom.gray_absolute
    }
}
