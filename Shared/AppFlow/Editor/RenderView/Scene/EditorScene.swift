//
//  EditorScene.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

import MetalKit
import HotMetal

final class EditorScene: Scene {

    private let node: PhotoNode
    private var start: Vector3 = .zero
    var project: Project { didSet { self.updateScene() } }
    
    init?(render: Render, source: CGImageSource.Source, project: Project) {
        guard let node = PhotoNode(render: render, source: source) else { return nil }
        self.node = node
        self.project = project
        super.init()
        self.nodes.append(node)
        self.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        
        let size = Float(render.view?.bounds.height ?? 0)
        camera = Camera(
            origin: [0, 0, -5],
            look: [0, 0, 1],
            up: [0, 1, 0],
            projection: .ortographic(size),
            aspectRatio: 1.0,
            nearZ: -10,
            farZ: 10
        )
        
        self.updateScene()
    }

    override func drawableSizeWillChange(_ view: MTKView, render: Render, size: CGSize) {
        node.update(viewSize: size)
        camera.update(projection: .ortographic(Float(size.height)))
    }
    
    private func updateScene() {
        switch project.focus {
        case .single(let focus):
            node.data = .init(x: focus.front, y: focus.rear, z: 0)
        case .custom:
            fatalError("Not implemented")
        }
    }
    
}
