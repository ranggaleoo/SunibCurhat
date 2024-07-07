//
//  RequestCallView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/07/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

protocol RequestCallViewDelegate: AnyObject {
    func didTapAccept(view: RequestCallView)
    func didTapReject(view: RequestCallView)
}

class RequestCallView: UIView {
    
    @IBOutlet private weak var container_view: UIView!
    @IBOutlet private weak var container_stack_view: UIStackView!
    @IBOutlet private weak var container_stack_btn_view: UIStackView!
    @IBOutlet private weak var lbl_title: UINCLabelTitle!
    @IBOutlet private weak var lbl_body: UINCLabelBody!
    @IBOutlet private weak var btn_accept: UINCButtonPrimaryRounded!
    @IBOutlet private weak var btn_reject: UINCButtonSecondaryRounded!
    
    weak var delegate: RequestCallViewDelegate?
    private var isFromCurrentSender: Bool?
    private var isCallable: Bool?
    private var conversation: Conversation? {
        didSet {
            updateUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        if let view = Bundle.main.loadNibNamed(String(describing: RequestCallView.self), owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
            addSubview(view)
            
            container_view.layer.cornerRadius     = 15
            container_view.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
            container_view.layer.shadowOffset     = CGSize(width: 0, height: 0)
            container_view.layer.shadowRadius     = 10.0
            container_view.layer.shadowOpacity    = 30.0
            container_view.layer.borderColor      = UINCColor.bg_tertiary.cgColor
            container_view.layer.borderWidth      = 1
            container_view.layer.masksToBounds    = false
            
            container_stack_view.spacing = 8
            container_stack_btn_view.spacing = 8
            
            lbl_title.textAlignment = .center
            lbl_body.textAlignment = .center
            lbl_body.numberOfLines = 0
            
            lbl_title.changeFontSize(size: 14)
            lbl_body.changeFontSize(size: 12)
            
            lbl_title.textColor = UIColor.label
            lbl_body.textColor = UIColor.label
            
            btn_accept.setTitle("Accept", for: .normal)
            btn_reject.setTitle("Reject", for: .normal)
            
            btn_accept.addTarget(self, action: #selector(acceptBtnHandler), for: .touchUpInside)
            btn_reject.addTarget(self, action: #selector(rejectBtnHandler), for: .touchUpInside)
       }
    }
    
    func set(conversation: Conversation?, isFromCurrentSender: Bool?, isCallable: Bool?) {
        self.isFromCurrentSender = isFromCurrentSender
        self.isCallable = isCallable
        self.conversation = conversation
    }
    
    private func updateUI() {
        self.accessibilityIdentifier = conversation?.conversation_id
        if let isFromCurrentSender = self.isFromCurrentSender, isFromCurrentSender {
            lbl_title.text = "Your Request Call"
            lbl_body.text = "Authorization required. Your request has been sent to \(conversation?.them().first?.name ?? "User") for approval."
            if let isCallable = self.isCallable {
                container_stack_btn_view.isHidden = false
                if isCallable {
                    btn_accept.setTitle("Accepted", for: .disabled)
                    btn_accept.isEnabled = false
                    btn_accept.isHidden = false
                    btn_reject.isHidden = true
                } else {
                    btn_reject.setTitle("Rejected", for: .disabled)
                    btn_reject.isEnabled = false
                    btn_reject.isHidden = false
                    btn_accept.isHidden = true
                }
            } else {
                container_stack_btn_view.isHidden = true
            }
        } else {
            lbl_title.text = "Request Call Received"
            lbl_body.text = "You have a call request from \(conversation?.them().first?.name ?? "User"). Do you prefer to let them call you? Please choose accept or reject. Ensure your safety and adherence to community guidelines. Block and report any suspicious or abusive behavior."
            
            if let isCallable = self.isCallable {
                container_stack_btn_view.isHidden = false
                if isCallable {
                    btn_accept.setTitle("Accepted", for: .disabled)
                    btn_accept.isEnabled = false
                    btn_accept.isHidden = false
                    btn_reject.isHidden = true
                } else {
                    btn_reject.setTitle("Rejected", for: .disabled)
                    btn_reject.isEnabled = false
                    btn_reject.isHidden = false
                    btn_accept.isHidden = true
                }
            } else {
                container_stack_btn_view.isHidden = false
                btn_accept.setTitle("Accept", for: .normal)
                btn_reject.setTitle("Reject", for: .normal)
                btn_accept.isEnabled = true
                btn_reject.isEnabled = true
                btn_accept.isHidden = false
                btn_accept.isHidden = false
            }
        }
        btn_accept.addTarget(self, action: #selector(acceptBtnHandler), for: .touchUpInside)
        btn_reject.addTarget(self, action: #selector(rejectBtnHandler), for: .touchUpInside)
    }
    
    @objc func acceptBtnHandler(_ sender: UIButton? = nil) {
        btn_accept.isEnabled = false
        delegate?.didTapAccept(view: self)
    }
    
    @objc func rejectBtnHandler(_ sender: UIButton? = nil) {
        btn_reject.isEnabled = false
        delegate?.didTapReject(view: self)
    }
}
