//
//  ImageProcessor.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 07.04.2022.
//

import UIKit
import SwiftUI

actor ImageProcessor {
    
    struct Focus {
        var rearDistance: CGFloat
        var frontDistance: CGFloat
    }

    private (set) var original: CGImage?

    private var previewSize: CGSize = .zero
    
    func set(source: CGImageSource) async -> CGImage? {
        assert(original == nil)

//        guard let buffer = CVPixelBuffer.open(source: source) else { return }
//        buffer.normolize()
//        if let image = buffer.image() {
//            await self.update(image: image)
//        }
        
        guard let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }

        self.original = cgImage
        
        return cgImage
    }

    func set(previewSize: CGSize) async -> CGImage? {
        return original
    }
    
    func set(focus: Focus) async -> CGImage? {
        return original
    }

}
