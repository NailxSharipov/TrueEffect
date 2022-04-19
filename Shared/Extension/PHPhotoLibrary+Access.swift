//
//  PHPhotoLibrary+Access.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import Photos
import SwiftUI
import UIKit

private enum Localization {
    static let alertTitle = NSLocalizedString("Local.PhotoLibrary.Alert.title", comment: "Access denied")
    static let alertMessage = NSLocalizedString("Local.PhotoLibrary.Alert.message", comment: "Would you like to open settings")
    static let cancelAction = NSLocalizedString("Local.Button.cancel", comment: "Cancel")
    static let openAction = NSLocalizedString("Local.PhotoLibrary.Alert.Action.open", comment: "Open settings")
}

extension UIViewController {

    func requestPhotoLibraryAccess(level: PHAccessLevel, callback: @escaping (Bool) -> ()) {
        assert(Thread.isMainThread)
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .restricted:
                callback(false)
            case .denied, .notDetermined:
                self.requestUpdateSettings() {
                    callback(false)
                }
            case .authorized, .limited:
                callback(true)
            @unknown default:
                callback(false)
            }
        }
    }
    
    private func requestUpdateSettings(failCallback: @escaping () -> ()) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            failCallback()
            return
        }
        
        let alert = UIAlertController(title: Localization.alertTitle, message: Localization.alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Localization.cancelAction, style: .cancel) { _ in
            failCallback()
        }
        let applyAction = UIAlertAction(title: Localization.openAction, style: .default) { _ in
            UIApplication.shared.open(url)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(applyAction)
        
        self.present(alert, animated: true, completion: nil)
    }
   
}

extension View {

//    func requestPhotoLibraryAccess(level: PHAccessLevel) async -> Bool {
//        let status = await PHPhotoLibrary.requestAuthorization(for: level)
//        switch status {
//        case .restricted:
//            return false
//        case .denied, .notDetermined:
//            self.requestUpdateSettings() {
//                callback(false)
//            }
//        case .authorized, .limited:
//            return true
//        @unknown default:
//            return false
//        }
//    }
    
    func openSettingsAlert() -> Alert {
        Alert(
            title: Text(Localization.alertTitle),
            message: Text(Localization.alertMessage),
            primaryButton: .default(Text(Localization.openAction)) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            },
            secondaryButton: .cancel()
        )
    }
}
