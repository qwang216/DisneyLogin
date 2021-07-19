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
    private let useUIKit: Bool

    private var payWallViewController: PaywallViewController?
    private var payWallView: PaywallView?

    private let networkService: DisneyNetworkServiceable

    init(window: UIWindow, useUIKit: Bool, networkService: DisneyNetworkServiceable) {
        self.window = window
        self.useUIKit = useUIKit
        self.networkService = networkService
    }

    func start() {
        if useUIKit {
            payWallViewController = PaywallViewController()
            payWallViewController?.delegate = self
            payWallViewController?.view.backgroundColor = .red
            window.rootViewController = payWallViewController
        } else {
            payWallView = PaywallView()
            window.rootViewController = UIHostingController(rootView: payWallView)
        }
        window.makeKeyAndVisible()
        fetchLoginPreference()
    }

    private func fetchLoginPreference() {
        networkService.getLoginPreference { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let preference):
                    self?.setLoginPreference(preference)
                case .failure(let err):
                    self?.showAlert(title: "Oops", message: err.localizedDescription)
                }
            }
        }
    }

    private func setLoginPreference(_ preference: LoginPreference) {
        let viewModel = PaywallViewModel(preference: preference)
        if useUIKit {
            payWallViewController?.payWallViewModel = viewModel
            payWallViewController?.view.backgroundColor = .red
        } else {
            payWallView?.payWallViewModel = viewModel
        }
    }

    private func showAlert(title: String, message: String) {
        if useUIKit {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let reloadAction = UIAlertAction(title: "Reload", style: .default) { [weak self] _ in
                self?.fetchLoginPreference()
            }
            alertView.addAction(reloadAction)
            payWallViewController?.present(alertView, animated: true, completion: nil)
        }
    }
}

extension AppCoordinator: PaywallViewDelegate {
    func userDidShakeDevice() {
        fetchLoginPreference()
    }
}
