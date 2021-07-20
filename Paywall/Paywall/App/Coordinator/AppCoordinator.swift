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

    var loginableView: LoginActionableView?

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

    /// Set Login Preference and only update UI when new theme is different from old
    private func setLoginPreference(_ preference: LoginPreference) {
        currViewModel = PaywallViewModel(preference: preference)
        guard let viewModel = currViewModel, let payWallViewController = payWallViewController else { return }
        guard payWallViewController.payWallViewModel?.theme != viewModel.theme else { return }
        payWallViewController.loginActionableView.removeFromSuperview()
        switch viewModel.theme {
        case .disney:
            loginableView = DisneyLoginActionableView.instanceFromNib()
        case .espn:
            loginableView = ESPNLoginActionableView.instanceFromNib()
            payWallViewController.midTileView = DisneyLoginMidTile.instanceFromNib()
        }
        configMidTileViewOn(paywallVC: payWallViewController, theme: viewModel.theme, preference: preference)
        if let validLoginableView = loginableView {
            payWallViewController.loginActionableView = validLoginableView
        }
        loginableView?.delegate = self
        payWallViewController.payWallViewModel = viewModel
    }

    private func configMidTileViewOn(paywallVC: PaywallViewController, theme: Theme, preference: LoginPreference) {
        paywallVC.midTileView.removeFromSuperview()
        switch theme {
        case .disney:
            let midTile = DisneyLoginMidTile.instanceFromNib()
            if let logoURL = preference.imageAssets.logo, let brandsURL = preference.imageAssets.brands, let quote = preference.subtexts.first {
                midTile.config(DisneyMidTileViewModel(mainLogoURL: logoURL, quote: quote, brandsURL: brandsURL))
            }
            paywallVC.midTileView = midTile
        case .espn:
            let midTile = ESPNLoginMidTile.instanceFromNib()
            if preference.subtexts.count == 2, let title = preference.subtexts.first, let subtitle = preference.subtexts.last {
                midTile.config(ESPNLoginMidTileViewModel(title: title, subTitle: subtitle))
            }
            paywallVC.midTileView = midTile
        }

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
