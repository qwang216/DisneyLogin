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

    private var currViewModel: PaywallViewModel?
    private var payWallViewController: PaywallViewController?

    private lazy var disneyLoginviewAble = DisneyLoginActionableView.instanceFromNib()
    private lazy var espnLoginviewAble = ESPNLoginActionableView.instanceFromNib()

    private let networkService: DisneyNetworkServiceable

    init(window: UIWindow, networkService: DisneyNetworkServiceable) {
        self.window = window
        self.networkService = networkService
    }

    func start() {
        payWallViewController = PaywallViewController()
        payWallViewController?.shakeDelegate = self
        window.rootViewController = payWallViewController
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
        currViewModel = PaywallViewModel(preference: preference)
        guard let viewModel = currViewModel else { return }
        payWallViewController?.loginActionableView.removeFromSuperview()
        switch viewModel.theme {
        case .disney:
            disneyLoginviewAble.delegate = self
            payWallViewController?.loginActionableView = disneyLoginviewAble
        case .espn:
            espnLoginviewAble.delegate = self
            payWallViewController?.loginActionableView = espnLoginviewAble
        }
        payWallViewController?.payWallViewModel = viewModel
    }

    private func showAlert(title: String, message: String) {
        payWallViewController?.showAlertView(title: title, message: message)
    }
}

extension AppCoordinator: LoginFlowViewDelegate {
    func didTapLoginButton() {
        payWallViewController?.showAlertView(title: "Log In", message: "")
    }

    func didTapSignupButton() {
        guard let viewModel = currViewModel else { return }
        payWallViewController?.showAlertView(title: "SKU", message: viewModel.sku)
    }


}

extension AppCoordinator: PaywallViewDelegate {
    func userDidShakeDevice() {
        fetchLoginPreference()
    }
}
