//
//  Float.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

private let epsilon: Float = 0.00001

extension Float {

    @inline(__always)
    func isPrettySame(_ value: Float) -> Bool {
        let delta = self - value
        return -epsilon < delta  && delta < epsilon
    }
    
}
