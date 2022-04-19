//
//  PhotoShotViewController+View.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import Foundation
import UIKit

extension PhotoShotViewController {
    
    final class View: UIView {
        
        private enum Layout {
            static let topBarHeight: CGFloat = 60
            static let bottomBarHeight: CGFloat = 100
            static let shotButtonRadius: CGFloat = 32
            static let buttonOffset: CGFloat = 32
        }

        let shotButton: UIView = ShotButton(lineWidth: 3, offset: 5, color: .white)
        
        let cancelButton: UIButton = {
            let button = UIButton()
            button.setTitle("Cancel", for: .normal)
            return button
        }()
        
        private let topBar: UIView = {
            let view = UIView()
            view.backgroundColor = .init(white: 0, alpha: 0.9)
            return view
        }()
        
        private let bottomBar: UIView = {
            let view = UIView()
            view.backgroundColor = .init(white: 0, alpha: 0.9)
            return view
        }()
        
        private let cameraWindow = CameraWindow(lineWidth: 1, unit: 32, color: .white)
        private var cameraLayer: CALayer?
        
        init() {
            super.init(frame: .zero)

            topBar.addSubview(cancelButton)
            bottomBar.addSubview(shotButton)
            
            self.addSubview(topBar)
            self.addSubview(bottomBar)
            self.layer.addSublayer(cameraWindow)
            
            cancelButton.setTitleColor(self.tintColor, for: .normal)
            
            backgroundColor = .black
        }
        
        required init?(coder: NSCoder) { return nil }
        
        override func layoutSubviews() {
            super.layoutSubviews()

            let topBarHeight = Layout.topBarHeight

            topBar.frame = CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: topBarHeight
            )

            let bottomHeight = Layout.bottomBarHeight + safeAreaInsets.bottom
            
            bottomBar.frame = CGRect(
                x: 0,
                y: bounds.height - bottomHeight,
                width: bounds.width,
                height: bottomHeight
            )
            
            cancelButton.sizeToFit()
            cancelButton.frame.origin = CGPoint(
                x: 16,
                y: 0.5 * (Layout.topBarHeight - cancelButton.frame.height)
            )
            
            shotButton.frame = CGRect(
                x: 0.5 * bottomBar.frame.width - Layout.shotButtonRadius,
                y: 0.5 * Layout.bottomBarHeight - Layout.shotButtonRadius,
                width: 2 * Layout.shotButtonRadius,
                height: 2 * Layout.shotButtonRadius
            )
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            if let layer = cameraLayer {
                layer.frame = bounds
            }

            cameraWindow.frame = CGRect(
                x: 0,
                y: topBar.frame.maxY,
                width: bounds.width,
                height: bottomBar.frame.minY - topBar.frame.maxY
            )
            
            CATransaction.commit()
        }
        
        func addCamera(layer: CALayer) {
            self.cameraLayer?.removeFromSuperlayer()
            self.cameraLayer = layer
            self.layer.insertSublayer(layer, at: 0)
            self.setNeedsLayout()
        }
        
        func showShotAnimation() {
            self.cameraLayer?.startAnimation()
        }

    }

    private final class CameraWindow: CAShapeLayer {
        
        private let unit: CGFloat
        
        init(lineWidth: CGFloat, unit: CGFloat, color: UIColor) {
            self.unit = unit
            super.init()
            self.strokeColor = color.cgColor
            self.fillColor = nil
            self.lineWidth = lineWidth
        }
        
        required init?(coder: NSCoder) { nil }
        
        override init(layer: Any) {
            self.unit = (layer as? CameraWindow)?.unit ?? 0
            super.init(layer: layer)
        }
        
        override func layoutSublayers() {
            super.layoutSublayers()

            let path = CGMutablePath()
            
            let a = unit
            var x = 0.5
            var y = 0.5

            // left top
            
            path.addLines(between:
                [
                    CGPoint(x: x + a, y: y),
                    CGPoint(x: x, y: y),
                    CGPoint(x: x, y: y + a)
                ]
            )
            
            // right top
            
            let depth = 0.5 * lineWidth
            
            x = bounds.width - depth
            y = depth
            
            path.addLines(between:
                [
                    CGPoint(x: x - a, y: y),
                    CGPoint(x: x, y: y),
                    CGPoint(x: x, y: y + a)
                ]
            )
            
            // left bottom
            
            x = depth
            y = bounds.height - depth
            
            path.addLines(between:
                [
                    CGPoint(x: x, y: y - a),
                    CGPoint(x: x, y: y),
                    CGPoint(x: x + a, y: y)
                ]
            )
            
            // right bottom
            
            x = bounds.width - depth
            y = bounds.height - depth
            
            path.addLines(between:
                [
                    CGPoint(x: x, y: y - a),
                    CGPoint(x: x, y: y),
                    CGPoint(x: x - a, y: y)
                ]
            )
            
            self.path = path
            self.strokeColor = UIColor.white.cgColor
        }
    }
    
    
    private final class ShotButton: UIView {

        private let offset: CGFloat
        private let ring = CAShapeLayer()
        private let circle = CAShapeLayer()
        
        init(lineWidth: CGFloat, offset: CGFloat, color: UIColor) {
            self.offset = offset
            super.init(frame: .zero)
            self.backgroundColor = .clear
            
            ring.lineWidth = lineWidth
            ring.strokeColor = color.cgColor
            ring.fillColor = nil
            
            circle.lineWidth = 0
            circle.strokeColor = nil
            circle.fillColor = color.cgColor
            
            layer.addSublayer(ring)
            layer.addSublayer(circle)
        }
        
        required init?(coder: NSCoder) { return nil }

        override func layoutSubviews() {
            super.layoutSubviews()
            
            let center = CGPoint(
                x: 0.5 * bounds.width,
                y: 0.5 * bounds.height
            )
            let radius = min(center.x, center.y)

            ring.path = UIBezierPath(
                arcCenter: center,
                radius: radius - 0.5 * ring.lineWidth,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            ).cgPath
            
            circle.path = UIBezierPath(
                arcCenter: center,
                radius: radius - 0.5 * ring.lineWidth - offset,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            ).cgPath
        }

        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let center = CGPoint(
                x: 0.5 * bounds.width,
                y: 0.5 * bounds.height
            )
            let radius = min(center.x, center.y)
            let dx = center.x - point.x
            let dy = center.y - point.y
            let isInside = dx * dx + dy * dy <= radius * radius
            
            return isInside
        }
    }

}

private extension CALayer {
 
    func startAnimation() {
        let pathAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        pathAnimation.duration = 0.4
        pathAnimation.values = [1, 0, 1]
        pathAnimation.keyTimes = [0, 0.5, 1]
        pathAnimation.isRemovedOnCompletion = true
        pathAnimation.repeatCount = 1

        CATransaction.begin()
        CATransaction.setAnimationDuration(pathAnimation.duration)
        self.add(pathAnimation, forKey: "opacity")
        
        CATransaction.commit()
    }
    
}
