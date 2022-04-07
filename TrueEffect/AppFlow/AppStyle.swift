//
//  AppStyle.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 05.04.2022.
//

import SwiftUI

final class AppStyle: ObservableObject {

    var tintColor: Color {
        let window = UIApplication.shared.keyWindow
        let color = window?.rootViewController?.view.tintColor ?? .red
        return Color(uiColor: color)
    }
    
}

private extension UIApplication {
    
    var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let activeScenes = scenes.filter { $0.activationState == .foregroundActive }
        let firstScene = activeScenes.first(where: { $0 is UIWindowScene })
        let windows = firstScene.flatMap({ $0 as? UIWindowScene })?.windows
        let window = windows?.first(where: \.isKeyWindow)
        return window
    }
    
}
