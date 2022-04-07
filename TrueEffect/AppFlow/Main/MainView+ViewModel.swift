//
//  MainView+ViewModel.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import SwiftUI
import Photos

extension MainView {
    
    final class ViewModel: ObservableObject {

        struct Sheet {
            enum Flow {
                case gallery
                case camera
            }
            
            let flow: Flow
            var isPresented: Bool
        }

        @Published var count: Int = 0
        @Published var sheet = Sheet(flow: .camera, isPresented: false)
        @Published var isEditor = false
        @Published var fileName: String = "" {
            didSet {
                sheet.isPresented = false
                isEditor = !fileName.isEmpty
            }
        }
        
        private let resource: Resource
        private (set) var drafts: [String] = []
        
        init(draftStore: DraftStore) {
            resource = Resource(draftStore: draftStore)
        }
        
    }
    
}

extension MainView.ViewModel {
    
    func load() async {
        let files = await self.resource.load()
        await self.update(drafts: files)
    }
    
    func onTap(id: Int) {
        fileName = drafts[id]
    }
    
    @MainActor
    private func update(drafts: [String]) {
        self.drafts = drafts
        self.count = drafts.count
    }

}
