//
//  Project.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 06.04.2022.
//

struct Project {
    
    enum Focus {
        
        struct Single {
            var front: Float
            var rear: Float
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

    var focus: Focus = .single(.init(front: 0.0, rear: 1.0))
    var apperture = Apperture(value: 0)
    var effect: Effect = .color(0)

}
