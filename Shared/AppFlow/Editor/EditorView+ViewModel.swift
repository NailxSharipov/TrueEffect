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

        struct Focus {
            var frontDistance: CGFloat
            var rearDistance: CGFloat
        }

        let projectState = ProjectState()
        @Published var isProgress: Bool = false
        @Published var topBarItems: [ToolsView.TopBarItemView.ViewModel] = []
        @Published var id: ToolsView.Id = .focus {
            didSet {
                guard oldValue != id else { return }
                self.updateItems()
            }
        }
        
        @Published
        var focus = Focus(frontDistance: 0, rearDistance: 1) {
            didSet {
                projectState.project.focus = focus.focus
            }
        }

        private let resource: Resource

        init(projectStore: ProjectStore) {
            self.resource = Resource(projectStore: projectStore)

        }
    }
}

extension EditorView.ViewModel {
    
    func onAppear() {
        self.updateItems()
    }
    
    func load(fileName: String) async {
        await self.update(progress: true)
        
        guard let imageSource = await resource.load(fileName: fileName) else {
            return
        }

        await self.update(imageSource: imageSource)
    }
    
    func onTapTopBar(id: ToolsView.Id) {
        self.id = id
    }

    @MainActor
    private func update(progress: Bool) async {
        isProgress = progress
    }
    
    @MainActor
    private func update(imageSource: CGImageSource?) async {
        isProgress = false
        if let imageSource = imageSource {
            projectState.imageSource = imageSource
            projectState.isReady = true
        }
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

private extension EditorView.ViewModel.Focus {
    
    func isPrettySame(_ focus: EditorView.ViewModel.Focus) -> Bool {
        focus.frontDistance.isPrettySame(frontDistance) && focus.rearDistance.isPrettySame(rearDistance)
    }
    
    var focus: Project.Focus {
        .single(.init(
            front: Float(frontDistance),
            rear: Float(rearDistance)
        ))
    }
}
