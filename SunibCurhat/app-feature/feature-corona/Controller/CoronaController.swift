//
//  CoronaController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit
import MapKit
import Crashlytics
import GoogleMobileAds

class CoronaController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment_control: UISegmentedControl!
    @IBOutlet weak var stackview_container_card: UIStackView!
    @IBOutlet weak var map_view: MKMapView!
    @IBOutlet weak var card_positif: UINCCardCorona!
    @IBOutlet weak var card_sembuh: UINCCardCorona!
    @IBOutlet weak var card_meninggal: UINCCardCorona!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.custom.gray
        r.attributedTitle = NSAttributedString(string: "Fetching Data", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    private lazy var lbl_source: UINCLabelBody = {
        let l = UINCLabelBody()
        l.text = "source : kawalcorona.com"
        l.font = UIFont.custom.regular.size(of: 10)
        l.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
        l.layer.shadowOffset     = CGSize(width: 5, height: 5)
        l.layer.shadowRadius     = 5.0
        l.layer.shadowOpacity    = 30.0
        l.layer.masksToBounds    = false
        return l
    }()
    
    var dataCovid : [CovidDataResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        setupViews()
        loadData()
        configAdUI()
    }
    
    private func delegate() {
        tableView.delegate      = self
        tableView.dataSource    = self
    }
    
    private func setupViews() {
        self.navigationDefault()
        self.title = "Covid-19"
        tableView.refreshControl                = refreshControl
        segment_control.selectedSegmentIndex    = 0
        map_view.isHidden                       = true
        stackview_container_card.isHidden       = false
        card_positif.backgroundColor    = UIColor.custom.red_absolute
        card_positif.title_color        = .white
        card_positif.body_color         = .white
        card_sembuh.backgroundColor     = UIColor.custom.blue_absolute
        card_sembuh.title_color         = .white
        card_sembuh.body_color          = .white
        card_meninggal.backgroundColor  = UIColor.custom.gray_absolute
        card_meninggal.title_color      = .white
        card_meninggal.body_color       = .white
        
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.view.addSubview(lbl_source)
        self.view.bringSubviewToFront(lbl_source)
        lbl_source.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbl_source.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lbl_source.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8)
        ])
    }
    
    private func overlayRadius(cases: Int) -> CLLocationDistance {
        switch cases {
        case 50000..<250000:
            return 150000
        case 17000..<50000:
            return 125000
        case 3000..<17000:
            return 100000
        case 1600..<3000:
            return 87500
        case 800..<1600:
            return 75000
        case 400..<800:
            return 67500
        case 200..<400:
            return 50000
        case 50..<200:
            return 37500
        case 10..<50:
            return 25000
        default:
            return 15000
        }
    }
    
    @objc private func loadData() {
        showLoaderIndicator()
        CoronaService.shared.getCovidDataGlobal { (result) in
            self.dismissLoaderIndicator()
            switch result {
            case .success(let s):
                s.forEach { (item) in
                    let coordinate          = CLLocationCoordinate2D(latitude: item.attributes.Lat, longitude: item.attributes.Long_)
                    let annotation          = MKPointAnnotation()
                    annotation.title        = item.attributes.Country_Region
                    annotation.subtitle     = "Total Cases: \(item.attributes.Confirmed)"
                    annotation.coordinate   = coordinate
                    self.map_view.removeAnnotation(annotation)
                    self.map_view.addAnnotation(annotation)
                }
            case .failure(let e):
                Crashlytics.sharedInstance().recordError(e)
            }
        }
        
        CoronaService.shared.getCovidData { (result) in
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.dismissLoaderIndicator()
            switch result {
            case .success(let s):
                self.dataCovid = s
                self.tableView.reloadData()
                
            case .failure(let e):
                Crashlytics.sharedInstance().recordError(e)
            }
        }
        
        CoronaService.shared.getSummaryCountry { (result) in
            self.dismissLoaderIndicator()
            switch result {
            case .success(let s):
                self.card_positif.title_text   = s[0].positif
                self.card_positif.body_text    = "Positive"
                self.card_sembuh.title_text    = s[0].sembuh
                self.card_sembuh.body_text     = "Recovered"
                self.card_meninggal.title_text = s[0].meninggal
                self.card_meninggal.body_text  = "Deaths"
                
            case .failure(let e):
                Crashlytics.sharedInstance().recordError(e)
            }
        }
    }
    
    private func configAdUI() {
        bannerView.isHidden = true
        MainService.shared.getAdBannerUnitID { (result) in
            switch result {
            case .failure(let e):
                debugLog(e.localizedDescription)
            case .success(let s):
                if s.success {
                    if let ad_unit_id = s.data {
                        self.bannerView.delegate = self
                        self.bannerView.adUnitID = ad_unit_id
                        self.bannerView.rootViewController = self
                        self.bannerView.load(GADRequest())
                    }
                }
            }
        }
    }
    
    @IBAction func indexSegmentIsChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            map_view.isHidden                   = true
            tableView.isHidden                  = false
            stackview_container_card.isHidden   = false
        case 1:
            map_view.isHidden                   = false
            tableView.isHidden                  = true
            stackview_container_card.isHidden   = true
        default: break
        }
    }
}
