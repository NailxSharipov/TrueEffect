//
//  MainView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject
    var viewModel = ViewModel(projectStore: ServiceLayer.shared.projectStore)

    var body: some View {
        ZStack {
            NavigationLink(destination: EditorView(fileName: viewModel.fileName), isActive: $viewModel.isEditor) {
                EmptyView()
            }.hidden()
            GeometryReader { geometryProxy in
                ScrollView(.vertical) {
                    grid(size: geometryProxy.size)
                }.task {
                    await viewModel.load()
                }
            }
        }
        .background(.black)
        .sheet(isPresented: $viewModel.sheet.isPresented) {
            switch viewModel.sheet.flow {
            case .gallery:
                GalleryView() { fileName in
                    viewModel.fileName = fileName ?? ""
                }
                EmptyView()
            case .camera:
                PhotoShotView() { fileName in
                    viewModel.fileName = fileName ?? ""
                }
            }
        }
        .navigationTitle("Navigator")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    print("Edit")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    viewModel.sheet = .init(flow: .camera, isPresented: true)
                } label: {
                    Image(systemName: "camera")
                }
                Button {
                    viewModel.sheet = .init(flow: .gallery, isPresented: true)
                } label: {
                    Image(systemName: "photo.on.rectangle")
                }
            }
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
                DraftImageView(projectStore: ServiceLayer.shared.projectStore, fileName: viewModel.drafts[id], size: cellSize)
                    .frame(width: a, height: a, alignment: .center)
                    .onTapGesture() {
                        viewModel.onTap(id: id)
                    }
            }
        }
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
