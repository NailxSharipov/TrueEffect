//
//  ServiceLayer.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

final class ServiceLayer {

    static let shared = ServiceLayer()

    let projectStore = ProjectStore()
    let appStyle = AppStyle()
    
}
