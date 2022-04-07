//
//  GalleryView+Resource.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import Photos
import ImageIO
import UIKit

extension GalleryView {
    
    final class Resource {
        
        fileprivate let draftStore: DraftStore
        
        init(draftStore: DraftStore) {
            self.draftStore = draftStore
        }
    }
    
}

extension GalleryView.Resource {
    
    func load() async -> [PHAsset] {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        let sortOrder = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = sortOrder

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var result = [PHAsset]()
        result.reserveCapacity(fetchResult.count)
        
        fetchResult.enumerateObjects { asset, index, pointer in
            if asset.mediaSubtypes == PHAssetMediaSubtype.photoDepthEffect {
                result.append(asset)
            }
        }
        
        return result
    }

    func save(asset: PHAsset) async -> String? {
        guard let url = await asset.requestURL() else { return nil }
        let name = "\(UUID().uuidString).\(url.pathExtension)"
        let success = await draftStore.copy(url: url, name: name, folder: .original)
        return success ? name : nil
    }
    
}

private extension PHAsset {

    func requestURL() async -> URL? {
        return await withCheckedContinuation { [weak self] continuation in
            self?.requestContentEditingInput(with: nil, completionHandler: { input, info in
                guard let input = input, let url = input.fullSizeImageURL else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: url)
            })
        }
    }

}
