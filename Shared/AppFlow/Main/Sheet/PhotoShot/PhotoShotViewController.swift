//
//  PhotoShotViewController.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import UIKit
import AVFoundation
import Photos

final class PhotoShotViewController: UIViewController {

    private let content = View()
    private var captureProcessor: CaptureProcessor?
    private let projectStore: ProjectStore
    private let callback: (String?) -> ()
    
    init(projectStore: ProjectStore, callback: @escaping (String?) -> ()) {
        self.projectStore = projectStore
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        self.view = content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    self?.setupCaptureProcessor()
                }
            }
        }

        content.shotButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takePhoto)))
        content.cancelButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureProcessor?.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureProcessor?.stop()
    }
    
    @objc private func takePhoto() {
        captureProcessor?.takeShot()
        content.showShotAnimation()
    }
    
    @objc private func dismissController() {
        self.callback(nil)
    }
    
    private func setupCaptureProcessor() {
        self.captureProcessor = CaptureProcessor()
        guard let processor = self.captureProcessor else { return }
        
        processor.onDidCapturePhoto = { [weak self] photo in
            self?.save(photo: photo)
        }

        
        let layer = AVCaptureVideoPreviewLayer(session: processor.session)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        content.addCamera(layer: layer)
        
        processor.start()
    }
    
    private func save(photo: AVCapturePhoto) {
        Task {
            if let data = photo.fileDataRepresentation() {
                let name = "\(UUID().uuidString).heic"
                if await projectStore.save(name: name, folder: .original, data: data) {
                    finish(fileName: name)
                }
            }
        }
    }
    
    @MainActor
    private func finish(fileName: String?) {
        callback(fileName)
    }

}

