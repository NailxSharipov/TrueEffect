//
//  MainView+Resource.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import SwiftUI

extension MainView {

    final class Resource {
        
        private let projectStore: ProjectStore
        
        init(projectStore: ProjectStore) {
            self.projectStore = projectStore
        }
        
    }
    
}

extension MainView.Resource {
    
    func load() async -> [String] {
        return await projectStore.load()
    }

}
