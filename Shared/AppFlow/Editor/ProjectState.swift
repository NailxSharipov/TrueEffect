//
//  ProjectState.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

import SwiftUI

final class ProjectState: ObservableObject {
    
    @Published
    var isReady: Bool = false
    
    var project = Project() {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @Published
    var imageSource: CGImageSource?
}
