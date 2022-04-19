//
//  GalleryView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import SwiftUI
import ImageIO

struct GalleryView: View {
    
    @StateObject
    var viewModel = ViewModel(projectStore: ServiceLayer.shared.projectStore)
    private let callback: (String?) -> ()
    
    init(callback: @escaping (String?) -> ()) {
        self.callback = callback
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel", action: {
                    callback(nil)
                }).padding(.leading, 20)
                Spacer()
            }
            .frame(height: 60)
            GeometryReader { geometryProxy in
                ScrollView(.vertical) {
                    grid(size: geometryProxy.size)
                }
            }
        }
        .onAppear() {
            viewModel.onAppear()
        }
    }
    
    private func grid(size: CGSize) -> some View {
        let space: CGFloat = 2
        let a = trunc(size.width / 3 - space)
        let cellSize = CGSize(width: a, height: a)
        
        let columns = [
            GridItem(.fixed(a)),
            GridItem(.fixed(a)),
            GridItem(.fixed(a))
        ]
        
        return LazyVGrid(columns: columns) {
            ForEach(0..<viewModel.count, id: \.self) { id in
                AssetImageView(asset: viewModel.assets[id], size: cellSize)
                    .frame(width: a, height: a, alignment: .center)
                    .onTapGesture() {
                        Task {
                            let fileName = await viewModel.onTap(id: id)
                            await MainActor.run {
                                callback(fileName)
                            }
                        }
                    }
            }
        }
    }
    
}
