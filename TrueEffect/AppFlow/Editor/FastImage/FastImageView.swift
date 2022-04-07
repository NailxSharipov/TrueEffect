//
//  FastImageView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 07.04.2022.
//

import SwiftUI

struct FastImageView: UIViewControllerRepresentable {

    private let image: CGImage?
    private let sizeCallback: (CGSize) -> ()
    
    init(image: CGImage?, sizeCallback: @escaping (CGSize) -> ()) {
        self.image = image
        self.sizeCallback = sizeCallback
    }
    
    func makeUIViewController(context: Context) -> FastImageViewController {
        FastImageViewController(sizeCallback: sizeCallback)
    }

    func updateUIViewController(_ uiViewController: FastImageViewController, context: Context) {
        uiViewController.renderView.update(image: self.image)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension FastImageView {

    final class Coordinator {

        let parent: FastImageView
        
        init(_ parent: FastImageView) {
            self.parent = parent
        }
    }
}

extension Binding {
    
    /// When the `Binding`'s `wrappedValue` changes, the given closure is executed.
    /// - Parameter closure: Chunk of code to execute whenever the value changes.
    /// - Returns: New `Binding`.
    func onUpdate(_ closure: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            wrappedValue = newValue
            closure(newValue)
        })
    }
}
