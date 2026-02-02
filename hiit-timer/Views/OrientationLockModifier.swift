//
//  OrientationLockModifier.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import SwiftUI
import UIKit

struct OrientationLockModifier: ViewModifier {
    let orientation: UIInterfaceOrientationMask
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                AppDelegate.orientationLock = orientation
                // Force orientation update
                if #available(iOS 16.0, *) {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
                    }
                } else {
                    // For iOS 15 and below, use UIDevice
                    UIDevice.current.setValue(orientationToUIInterfaceOrientation(orientation), forKey: "orientation")
                }
            }
            .onDisappear {
                // Reset to all orientations when view disappears
                AppDelegate.orientationLock = .all
            }
    }
    
    private func orientationToUIInterfaceOrientation(_ mask: UIInterfaceOrientationMask) -> Int {
        switch mask {
        case .portrait:
            return UIInterfaceOrientation.portrait.rawValue
        case .landscape:
            return UIInterfaceOrientation.landscapeLeft.rawValue
        default:
            return UIInterfaceOrientation.portrait.rawValue
        }
    }
}

extension View {
    func orientationLock(_ orientation: UIInterfaceOrientationMask) -> some View {
        modifier(OrientationLockModifier(orientation: orientation))
    }
}

// Helper class to manage orientation
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

