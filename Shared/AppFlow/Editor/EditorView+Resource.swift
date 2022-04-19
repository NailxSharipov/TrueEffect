//
//  EditorView+Resource.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import SwiftUI

extension EditorView {

    final class Resource {
        
        private var fileName: String = ""
        private let projectStore: ProjectStore
        
        init(projectStore: ProjectStore) {
            self.projectStore = projectStore
        }

    }
    
}

extension EditorView.Resource {
    
    func load(fileName: String) async -> CGImageSource? {
        guard let source = await projectStore.read(name: fileName, folder: .original) else {
            return nil
        }
        
        self.fileName = fileName
        
        return source
    }

}
