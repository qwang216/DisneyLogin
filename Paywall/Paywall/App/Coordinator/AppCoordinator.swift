//
//  AppCoordinator.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit
import SwiftUI

class AppCoordinator {
    private let window: UIWindow
    private let networkService: DisneyNetworkServiceable
    let navController: UINavigationController
    let splashViewController = UIViewController()
    var authCoordinator: AuthCoordinator?
    var isAuthenticated: Bool = false

    init(window: UIWindow, networkService: DisneyNetworkServiceable) {
        self.window = window
        self.networkService = networkService
        self.navController = UINavigationController()
    }

    func start() {
        splashViewController.view.backgroundColor = .white
        navController.setViewControllers([splashViewController], animated: true)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        if !isAuthenticated {
            startAuthCoordinator()
        }
    }

    private func startAuthCoordinator() {
        authCoordinator = AuthCoordinator(navController: navController, service: networkService)
        authCoordinator?.start()
    }
}
