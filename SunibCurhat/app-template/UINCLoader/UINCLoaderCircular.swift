//
//  UINCLoaderCircular.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

final class UINCLoaderCircular: UIView {

    // MARK: - UI objects
    private lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }()

    private lazy var miniCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()

    // MARK: - Initializers and Life cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }

    private func setupViews() {
        self.clipsToBounds = false
        
        self.addSubview(self.circleView)
        NSLayoutConstraint.activate([
            self.circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.circleView.topAnchor.constraint(equalTo: self.topAnchor),
            self.circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.addSubview(self.miniCircleView)
        NSLayoutConstraint.activate([
            self.miniCircleView.widthAnchor.constraint(equalToConstant: 24),
            self.miniCircleView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.circleView.layer.cornerRadius = self.circleView.frame.width / 2.0
        self.miniCircleView.layer.cornerRadius = self.miniCircleView.frame.width / 2.0
        
        self.miniCircleView.center = self.getPoint(for: -90)
    }

    func setColorCircular(_ color: UIColor) {
        circleView.backgroundColor = color
    }

    func setColorMiniCircular(_ color: UIColor) {
        miniCircleView.backgroundColor = color
    }

    // MARK: - Animation
    func startAnimating() {
        let path = UIBezierPath()
        let initialPoint = self.getPoint(for: -90)
        path.move(to: initialPoint)
        for angle in -89...0 { path.addLine(to: self.getPoint(for: angle)) }
        for angle in 1...270 { path.addLine(to: self.getPoint(for: angle)) }
        path.close()
        self.animate(view: self.miniCircleView, path: path)
    }

    private func animate(view: UIView, path: UIBezierPath) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = Float.infinity
        animation.duration = 5
        view.layer.add(animation, forKey: "animation")
    }

    private func getPoint(for angle: Int) -> CGPoint {
        let radius = Double(self.circleView.frame.width / 2.0)
        let radian = Double(angle) * Double.pi / Double(180)
        let newCenterX = radius + radius * cos(radian)
        let newCenterY = radius + radius * sin(radian)
        return CGPoint(x: newCenterX, y: newCenterY)
    }
}
