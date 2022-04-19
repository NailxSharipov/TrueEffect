//
//  AssetImageView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import SwiftUI
import Photos

struct AssetImageView: View {
    
    enum StateCase {
        case progress
        case image(UIImage)
        case fail
    }

    @State
    private var state: StateCase = .progress
    private let asset: PHAsset
    private let size: CGSize
    
    init(asset: PHAsset, size: CGSize) {
        self.asset = asset
        self.size = size
    }
    
    var body: some View {
        switch state {
        case .progress:
            ProgressView()
                .frame(alignment: .center)
                .onAppear() {
                    self.load()
                }
        case .image(let image):
            Image(uiImage: image)
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height, alignment: .center)
                .clipped()
        case .fail:
            Image(systemName: "xmark.octagon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
        }
    }
    
    private func load() {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.resizeMode = .fast
        options.version = .current

        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, info in
            if let image = image {
                DispatchQueue.main.async {
                    state = .image(image)
                }
            }
        }
    }
    
}
