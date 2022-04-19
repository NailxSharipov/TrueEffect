//
//  CGFloat.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 08.04.2022.
//

import CoreGraphics

private let epsilon: CGFloat = 0.000000001

extension CGFloat {

    @inline(__always)
    func isPrettySame(_ value: CGFloat) -> Bool {
        let delta = self - value
        return -epsilon < delta  && delta < epsilon
    }
    
}

extension CGSize {

    @inline(__always)
    func isPrettySame(_ size: CGSize) -> Bool {
        size.width.isPrettySame(width) && size.height.isPrettySame(height)
    }
    
}
