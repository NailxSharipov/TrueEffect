//
//  TrueEffectAppDelegate.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 05.04.2022.
//

import UIKit
import SwiftUI

final class TrueEffectAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        debugPrint("didFinishLaunch")
        return true
    }
}
