//
//  MainView+Resource.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import SwiftUI

extension MainView {

    final class Resource {
        
        private let draftStore: DraftStore
        
        init(draftStore: DraftStore) {
            self.draftStore = draftStore
        }
        
    }
    
}

extension MainView.Resource {
    
    func load() async -> [String] {
        return await draftStore.load()
    }

}
