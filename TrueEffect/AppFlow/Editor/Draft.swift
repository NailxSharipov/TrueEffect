//
//  Draft.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 06.04.2022.
//

class Draft {

    enum Focus {
        
        struct Single {
            var rear: Float
            var front: Float
        }
        
        case single(Single)
        case custom
    }

    struct Apperture {
        var value: Float
    }
    
    enum Effect {
        case color(UInt)
        case puzzle
    }

    var focus: Focus = .single(.init(rear: 0.8, front: 0.2))
    var apperture = Apperture(value: 0)
    var effect: Effect = .color(0)
    
}
