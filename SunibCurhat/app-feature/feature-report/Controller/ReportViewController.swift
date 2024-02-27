//
//  ReportViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 9/11/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var reportTableView: UITableView!
    
    var timeline: TimelineItems?
    var chat: Chat?
    var reportOptions: [String] = [
        "Nudity or pornography",
        "Hate speech or symbols",
        "Violence or threat of violence",
        "Sale or promotion of firearms",
        "Sale or promotion of drugs",
        "Harassment or bullying",
        "Intellectual property violation",
        "Self injury",
        "It's Spam"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        let reports = preferences?.report_reasons
        if let report_reasons = reports {
            reportOptions = report_reasons
            reportTableView.reloadData()
        }
    }
    
    private func delegates() {
        title = "Report"
        reportTableView.delegate    = self
        reportTableView.dataSource  = self
        reportTableView.tableFooterView = UIView()
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell") as! ReportTableViewCell
        cell.option = reportOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let timelineUnwrap = timeline {
            self.showLoaderIndicator()
            let user = UDHelpers.shared.getObject(type: User.self, forKey: .user)
            ReportService.shared.report(reportBy: user?.user_id ?? "", user_id: timelineUnwrap.user_id, reason: reportOptions[indexPath.row], proof_id: "\(timelineUnwrap.timeline_id)", proof: timelineUnwrap.text_content) { (result) in
                switch result {
                case .success(let success):
                    self.dismissLoaderIndicator()
                    if success.success {
                        self.showAlert(title: "Success", message: success.message, OKcompletion: nil, CancelCompletion: nil)
                    } else {
                        self.showAlert(title: "Error", message: success.message, OKcompletion: nil, CancelCompletion: nil)
                    }
                case .failure(let error):
                    self.dismissLoaderIndicator()
                    self.showAlert(title: "Error", message: error.localizedDescription, OKcompletion: { (act) in
                        RepoMemory.token = nil
                    }, CancelCompletion: nil)
                }
            }
        
        } else if let chatUnwrap = self.chat {
            self.showLoaderIndicator()
            let user = UDHelpers.shared.getObject(type: User.self, forKey: .user)
            ReportService.shared.report(reportBy: user?.user_id ?? "", user_id: chatUnwrap.chat_id, reason: reportOptions[indexPath.row], proof_id: chatUnwrap.id, proof: chat?.name) { (result) in
                switch result {
                case .failure(let e):
                    self.dismissLoaderIndicator()
                    self.showAlert(title: "Error", message: e.localizedDescription, OKcompletion: { (act) in
                        RepoMemory.token = nil
                    }, CancelCompletion: nil)
                    
                case .success(let s):
                    self.dismissLoaderIndicator()
                    if s.success {
                        self.showAlert(title: "Success", message: s.message, OKcompletion: nil, CancelCompletion: nil)
                    } else {
                        self.showAlert(title: "Error", message: s.message, OKcompletion: nil, CancelCompletion: nil)
                    }
                }
            }
        }
    }
}

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_option: UILabel!
    
    var option: String? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.lbl_option.text = self.option
        }
    }
}
