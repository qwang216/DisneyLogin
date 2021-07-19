//
//  SceneDelegate.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming Services. All rights reserved.
//

import UIKit
import SwiftUI

let useUIKit = true

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var appCoordinator: AppCoordinator?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window: window!, networkService: DisneyNetworkService())
        appCoordinator?.start()
    }
}

