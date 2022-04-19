//
//  RenderView+ViewModel.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

import SwiftUI
import HotMetal
import Combine

extension RenderView {
    
    final class ViewModel: ObservableObject {

        let render: Render
        var projectState: ProjectState? {
            didSet {
                guard let state = projectState, projectStateCancellable == nil else { return }
                projectStateCancellable = state.objectWillChange.sink { [weak self] in
                    self?.updateProject()
                }
                self.updateProject()
            }
        }
        
        private var projectStateCancellable: AnyCancellable?
        private var editorScene: EditorScene?

        init() {
            self.render = Render()
            self.render.onViewReady = { [weak self] render in
                self?.updateProject()
            }
        }

        private func updateProject() {
            guard let projectState = self.projectState else { return }
            if let scene = editorScene {
                scene.project = projectState.project
                debugPrint(projectState.project)
            } else if let source = projectState.imageSource?.source(device: render.device) {
                let scene = EditorScene(render: render, source: source, project: projectState.project)
                self.editorScene = scene
                render.scene = scene

            }
        }
        
        func save() {
            debugPrint("Save")
            let render = Render(pixelFormat: .bgra8Unorm_srgb, depthAttachmentPixelFormat: .invalid)
            guard let source = projectState?.imageSource?.source(device: render.device) else { return }
            
            let width = source.image.width
            let height = source.image.height
            let saveScene = SaveScene(render: render, source: source)
            render.scene = saveScene

            guard let texture = render.doShot(width: width, height: height) else {
                return
            }
            
            let image = texture.image()
            
            debugPrint(image)
        }
        
    }
}
