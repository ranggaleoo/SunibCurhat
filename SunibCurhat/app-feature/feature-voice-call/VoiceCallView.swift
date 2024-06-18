//
//  VoiceCallView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 15/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation

class VoiceCallView: UIViewController, VoiceCallPresenterToView {
    var presenter: VoiceCallViewToPresenter?
    
    private var joinButton: UIButton!
    private var leaveButton: UIButton!
    private var statusLabel: UILabel!
    
    init() {
        super.init(nibName: String(describing: VoiceCallView.self), bundle: Bundle(for: VoiceCallView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        joinButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        joinButton.center = view.center
        joinButton.setTitle("Join Call", for: .normal)
        joinButton.setTitleColor(.blue, for: .normal)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        view.addSubview(joinButton)
        
        leaveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        leaveButton.center = CGPoint(x: view.center.x, y: view.center.y + 60)
        leaveButton.setTitle("Leave Call", for: .normal)
        leaveButton.setTitleColor(.red, for: .normal)
        leaveButton.addTarget(self, action: #selector(leaveButtonTapped), for: .touchUpInside)
        leaveButton.isHidden = true
        view.addSubview(leaveButton)
        
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        statusLabel.center = CGPoint(x: view.center.x, y: view.center.y - 60)
        statusLabel.textAlignment = .center
        statusLabel.text = "Not in call"
        view.addSubview(statusLabel)
    }
    
    func updateUIForJoinChannel() {
        joinButton.isHidden = true
        leaveButton.isHidden = false
        statusLabel.text = "In call"
    }
    
    func updateUIForLeaveChannel() {
        joinButton.isHidden = false
        leaveButton.isHidden = true
        statusLabel.text = "Not in call"
    }
    
    @objc private func joinButtonTapped() {
        presenter?.joinCall()
    }
    
    @objc private func leaveButtonTapped() {
        presenter?.leaveCall()
    }
}
