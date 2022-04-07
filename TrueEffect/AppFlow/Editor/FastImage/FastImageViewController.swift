//
//  FastImageViewController.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 07.04.2022.
//

import UIKit
import SwiftUI
import Combine

final class FastImageViewController: UIViewController {
    
    final class RenderView: UIView {
        
        private let sizeCallback: (CGSize) -> ()
        
        private var image: CGImage?
        
        init(sizeCallback: @escaping (CGSize) -> ()) {
            self.sizeCallback = sizeCallback
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) { nil }
        
        override func draw(_ rect: CGRect) {
            guard let cgImage = self.image else { return }
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            context.saveGState()
            
            context.translateBy(x: 0, y: rect.height)
            context.scaleBy(x: 1, y: -1)
            context.draw(cgImage, in: rect)
            
            context.restoreGState()
        }
        
        override func layoutSubviews() {
            sizeCallback(bounds.size)
        }
        
        func update(image: CGImage?) {
            self.image = image
            self.setNeedsDisplay()
        }
        
    }
    
    let renderView: RenderView
    
    init(sizeCallback: @escaping (CGSize) -> ()) {
        self.renderView = RenderView(sizeCallback: sizeCallback)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = renderView
    }
}
