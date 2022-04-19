//
//  CaptureProcessor.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import AVFoundation
import UIKit

final class CaptureProcessor {

    let session: AVCaptureSession
    private let device: AVCaptureDevice
    private let output: AVCapturePhotoOutput
    private let photoSolver = CaptureProcessorPhotoSolver()
    
    var onDidCapturePhoto: ((AVCapturePhoto) -> ())? {
        get {
            photoSolver.onDidCapturePhoto
        }
        
        set {
            photoSolver.onDidCapturePhoto = newValue
        }
    }
    
    init?() {
        guard let aDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else { return nil }
        
        output = AVCapturePhotoOutput()
        
        device = aDevice
        session = AVCaptureSession()
        
        guard
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input),
            session.canAddOutput(output)
        else { return nil }
        
        session.beginConfiguration()
        
        session.sessionPreset = .photo
        session.addInput(input)
        session.addOutput(output)

        guard
            output.availablePhotoFileTypes.contains(.heic),
            output.isDepthDataDeliverySupported
        else { return nil }
        
        session.commitConfiguration()
        output.isHighResolutionCaptureEnabled = true
        output.isDepthDataDeliveryEnabled = true
    }
    
    deinit {
        self.stop()
    }
    
    func start() {
        guard !session.isRunning else { return }
        DispatchQueue.global().async { [weak self] in
            self?.session.startRunning()
        }
        
    }
    
    func stop() {
        guard session.isRunning else { return }
        session.stopRunning()
    }
    
    func takeShot() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        settings.embedsDepthDataInPhoto = true
        settings.isDepthDataDeliveryEnabled = true
        settings.isDepthDataFiltered = true

        output.capturePhoto(with: settings, delegate: photoSolver)
    }

}

final class CaptureProcessorPhotoSolver: NSObject, AVCapturePhotoCaptureDelegate {
    
    fileprivate var onDidCapturePhoto: ((AVCapturePhoto) -> ())?
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        assert(Thread.isMainThread)
        onDidCapturePhoto?(photo)
    }
    
}
