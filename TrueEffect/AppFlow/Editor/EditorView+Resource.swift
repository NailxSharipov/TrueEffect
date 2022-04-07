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
        private let draftStore: DraftStore
        
        init(draftStore: DraftStore) {
            self.draftStore = draftStore
        }

    }
    
}

extension EditorView.Resource {
    
    func load(fileName: String) async -> CGImageSource? {
        guard let source = await draftStore.read(name: fileName, folder: .original) else {
            return nil
        }
        
        self.fileName = fileName
        
        return source
    }

}
