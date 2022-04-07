//
//  EditorView+ViewModel.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 02.04.2022.
//

import SwiftUI
import PhotosUI
import ImageIO

extension EditorView {

    final class ViewModel: ObservableObject {

        @Published var isProgress: Bool = false
        @Published var prevImage: CGImage?
        @Published var topBarItems: [ToolsView.TopBarItemView.ViewModel] = []
        @Published var id: ToolsView.Id = .focus {
            didSet {
                guard oldValue != id else { return }
                self.updateItems()
            }
        }

        @Published
        var previewSize: CGSize = .zero {
            didSet {
                Task { [weak self] in
                    let image = await self?.processor.set(previewSize: previewSize)
                    await MainActor.run { [weak self] in
                        self?.prevImage = image
                    }
                }
            }
        }
        
        @Published
        var focus: ImageProcessor.Focus = .init(rearDistance: 0.1, frontDistance: 0.9) {
            didSet {
                Task { [weak self] in
                    let image = await self?.processor.set(focus: focus)
                    await MainActor.run { [weak self] in
                        self?.prevImage = image
                    }
                }
            }
        }

        var processor = ImageProcessor()
        private let resource: Resource

        init(draftStore: DraftStore) {
            self.resource = Resource(draftStore: draftStore)
        }
    }
}

extension EditorView.ViewModel {
    
    func onAppear() {
        self.updateItems()
    }
    
    func load(fileName: String) async {
        await self.update(progress: true)
        
        guard let source = await resource.load(fileName: fileName) else {
            return
        }

        let image = await self.processor.set(source: source)

        await self.update(image: image)
    }
    
    func onTapTopBar(id: ToolsView.Id) {
        self.id = id
    }

    @MainActor
    private func update(progress: Bool) async {
        isProgress = progress
    }
    
    @MainActor
    private func update(image: CGImage?) async {
        isProgress = false
        prevImage = image
    }
    
    private func updateItems() {
        topBarItems = [
            self.item(id: .focus),
            self.item(id: .aperture),
            self.item(id: .effect)
        ]
    }
    
    private func item(id: ToolsView.Id) -> ToolsView.TopBarItemView.ViewModel {
        let title: String
        let image: Image
        switch id {
        case .focus:
            title = "Focus"
            image = Image(systemName: "viewfinder")
        case .aperture:
            title = "Aperture"
            image = Image(systemName: "camera.aperture")
        case .effect:
            title = "Effect"
            image = Image(systemName: "wand.and.stars")
        }
        
        let isActive = self.id == id
        
        let color: Color = isActive ? .tintColor : .gray
        let fontWeight: Font.Weight = isActive ? .semibold : .regular
        
        return .init(id: id, title: title, image: image, color: color, fontWeight: fontWeight)
    }

    
    func save() async {
        
    }

}
