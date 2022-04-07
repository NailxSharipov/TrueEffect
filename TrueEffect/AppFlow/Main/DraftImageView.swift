//
//  DraftImageView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import SwiftUI
import Photos

struct DraftImageView: View {
    
    enum StateCase {
        case progress
        case image(UIImage)
        case fail
    }

    private let draftStore: DraftStore
    
    @State
    private var state: StateCase = .progress
    private let fileName: String
    private let size: CGSize
    
    init(draftStore: DraftStore, fileName: String, size: CGSize) {
        self.draftStore = draftStore
        self.fileName = fileName
        self.size = size
    }
    
    var body: some View {
        switch state {
        case .progress:
            ProgressView()
                .frame(alignment: .center)
                .task {
                    await self.load()
                }
        case .image(let image):
            Image(uiImage: image)
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height, alignment: .center)
                .clipped()
        case .fail:
            Image(systemName: "xmark.octagon")
                .frame(width: 100, height: 100, alignment: .center)
        }
    }
    
    private func load() async {
        let image = await draftStore.loadThumbnail(name: fileName, size: size)
        await MainActor.run {
            if let image = image {
                state = .image(image)
            } else {
                state = .fail
            }
        }
    }
    
}
