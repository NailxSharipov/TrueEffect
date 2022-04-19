//
//  PhotoNode.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

import MetalKit
import HotMetal

final class PhotoNode: Node {

    public var data = Vector3(0, 0, 0)
    private let source: CGImageSource.Source
    private let device: MTLDevice
    
    init?(render: Render, source: CGImageSource.Source) {
        self.device = render.device
        self.source = source

        let texture0 = render.textureLibrary.loadTexture(image: source.image, gammaCorrection: true)
        let texture1 = render.textureLibrary.register(texture: source.depth)
        
        let piplineState = Material.texture(
            render: render,
            blendMode: .opaque,
            vertex: .local("vertexSave"),
            fragment: .local("fragmentSave")
        )
        
        let material = render.materialLibrary.register(state: piplineState)
        material.isAffectDepthBuffer = false

        material.textures.append(texture0)
        material.textures.append(texture1)

        let width = Float(source.image.width)
        let height = Float(source.image.height)
        
        let mesh = Self.buildMesh(device: render.device, width: width, height: height)
        
        super.init(mesh: mesh, material: material)
    }
    
    override func draw(context: DrawContext, parentTransform: Matrix4) {
        context.encoder.setFragmentBytes(&data, length: MemoryLayout<Vector3>.size, index: Render.firstFreeVertexBufferIndex + 1)
        super.draw(context: context, parentTransform: parentTransform)
    }
    
    func update(viewSize: CGSize) {
        let width = Float(viewSize.width)
        let height = Float(viewSize.height)
        self.mesh = Self.buildMesh(device: device, width: width, height: height)
    }
    
    private static func buildMesh(device: MTLDevice, width: Float, height: Float) -> Mesh {
        let color = Vector4(CGColor(gray: 1, alpha: 1))
        let a = 0.5 * width
        let b = 0.5 * height
        
        let vertices: [TextureVertex] = [
            TextureVertex(position: .init(x: -a, y: -b, z: 0), color: color, uv: Vector2(x: 0, y: 1)),
            TextureVertex(position: .init(x: -a, y:  b, z: 0), color: color, uv: Vector2(x: 0, y: 0)),
            TextureVertex(position: .init(x:  a, y:  b, z: 0), color: color, uv: Vector2(x: 1, y: 0)),
            TextureVertex(position: .init(x:  a, y: -b, z: 0), color: color, uv: Vector2(x: 1, y: 1))
        ]

        let indices: [UInt16] = [0, 1, 2, 0, 2, 3]
        
        let vertexSize = vertices.count * MemoryLayout.size(ofValue: vertices[0])
        let vertexBuffer = device.makeBuffer(bytes: vertices, length: vertexSize, options: [.cpuCacheModeWriteCombined])!

        let indexSize = indices.count * MemoryLayout.size(ofValue: indices[0])
        let indexBuffer = device.makeBuffer(bytes: indices, length: indexSize, options: [.cpuCacheModeWriteCombined])!

        return Mesh(vertexBuffer: vertexBuffer, indexBuffer: indexBuffer, count: indices.count)
    }
    
}
