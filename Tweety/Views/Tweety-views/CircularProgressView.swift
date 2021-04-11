//
//  CircularProgressView.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//


import UIKit

class CircularProgressView: UIView {
    
    var progressStrokeColor: UIColor = .white {
        didSet { progressLayer.strokeColor = progressStrokeColor.cgColor }
    }
    
    var defaultStrokeColor: UIColor = .black {
        didSet { backgroundMask.strokeColor = defaultStrokeColor.cgColor}
    }
    
    var ringWidth: CGFloat = 2

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = defaultStrokeColor.cgColor
        layer.mask = backgroundMask
        layer.addSublayer(backgroundMask)

        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = min(progress, 1)
        progressLayer.strokeColor = progressStrokeColor.cgColor
    }
}
