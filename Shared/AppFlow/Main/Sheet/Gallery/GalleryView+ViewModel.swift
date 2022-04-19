//
//  GalleryView+ViewModel.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import SwiftUI
import Photos

extension GalleryView {
 
    final class ViewModel: ObservableObject {
        
        @Published var count: Int = 0
        
        private (set) var assets = [PHAsset]()

        private let resource: Resource
        
        init(projectStore: ProjectStore) {
            resource = Resource(projectStore: projectStore)
        }
        
    }
}

extension GalleryView.ViewModel {
    
    func onAppear() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                debugPrint("notDetermined")
            case .restricted:
                debugPrint("restricted")
            case .denied:
                debugPrint("denied")
            case .authorized, .limited:
                debugPrint("authorized")
                Task { [weak self] in
                    await self?.load()
                }
            @unknown default:
                debugPrint("nothing")
            }
        }
    }
    
    func onTap(id: Int) async -> String? {
        return await resource.save(asset: assets[id])
    }
    
    private func load() async {
        let assets = await self.resource.load()
        await self.update(assets: assets)
    }
    
    @MainActor
    private func update(assets: [PHAsset]) {
        self.assets = assets
        self.count = assets.count
    }
}
