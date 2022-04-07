//
//  PhotoShotView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import SwiftUI
import ImageIO

struct PhotoShotView: UIViewControllerRepresentable {

    private let callback: (String?) -> ()
    
    init(callback: @escaping (String?) -> ()) {
        self.callback = callback
    }
    
    func makeUIViewController(context: Context) -> PhotoShotViewController {
        PhotoShotViewController(draftStore: ServiceLayer.shared.draftStore, callback: callback)
    }

    func updateUIViewController(_ uiViewController: PhotoShotViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension PhotoShotView {

    class Coordinator {
      
        private let parent: PhotoShotView
        
        init(_ parent: PhotoShotView) {
            self.parent = parent
        }
    }
}
