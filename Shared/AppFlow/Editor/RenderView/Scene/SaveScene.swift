//
//  SaveScene.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

import MetalKit
import HotMetal

final class SaveScene: Scene {

    private let node: PhotoNode
    private var start: Vector3 = .zero

    var front: Float = 0 {
        didSet {
            node.data = Vector3(front, rear, glow)
        }
    }
    var rear: Float = 0 {
        didSet {
            node.data = Vector3(front, rear, glow)
        }
    }
    var glow: Float = 0 {
        didSet {
            node.data = Vector3(front, rear, glow)
        }
    }
    
    init?(render: Render, source: CGImageSource.Source) {
        guard let node = PhotoNode(render: render, source: source) else { return nil }
        self.node = node
        super.init()
        self.nodes.append(node)
        self.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)

        let width = Float(source.image.width)
        let height = Float(source.image.height)
        
        camera = Camera(
            origin: [0, 0, -5],
            look: [0, 0, 1],
            up: [0, 1, 0],
            projection: .ortographic(height),
            aspectRatio: width / height,
            nearZ: -10,
            farZ: 10
        )

        // invert to image coordinate system
        camera.viewMatrix = camera.viewMatrix * Matrix4.scale(1, -1, 1)
    }
    
}
