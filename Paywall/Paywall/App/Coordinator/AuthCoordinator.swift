//
//  AuthCoordinator.swift
//  Paywall
//
//  Created by Jason wang on 7/29/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

class AuthCoordinator {

    let navigationController: UINavigationController
    let networkService: DisneyNetworkServiceable
    init(navController: UINavigationController, service: DisneyNetworkServiceable) {
        self.navigationController = navController
        self.networkService = service
    }

    private var payWallViewController: PaywallViewController?
    private var currViewModel: PaywallViewModel?
    var loginableView: LoginActionableView?

    func start() {
        payWallViewController = PaywallViewController()
        payWallViewController?.modalPresentationStyle = .fullScreen
        payWallViewController?.shakeDelegate = self
        navigationController.topViewController?.present(payWallViewController!, animated: true, completion: nil)
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
        configLoginableView(paywallVC: payWallViewController, theme: viewModel.theme)
        configMidTileViewOn(paywallVC: payWallViewController, preference: preference)
        if let validLoginableView = loginableView {
            payWallViewController.loginActionableView = validLoginableView
        }
        loginableView?.delegate = self
        payWallViewController.payWallViewModel = viewModel
    }

    private func configLoginableView(paywallVC: PaywallViewController, theme: Theme) {
        paywallVC.loginActionableView.removeFromSuperview()
        switch theme {
        case .disney:
            loginableView = DisneyLoginActionableView.instanceFromNib()
        case .espn:
            loginableView = ESPNLoginActionableView.instanceFromNib()
        }
    }

    private func configMidTileViewOn(paywallVC: PaywallViewController, preference: LoginPreference) {
        paywallVC.midTileView.removeFromSuperview()
        switch preference.theme {
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

extension AuthCoordinator: LoginFlowViewDelegate {
    func didTapLoginButton() {
        payWallViewController?.showAlertView(title: "Log In", message: "")
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }

    func didTapSignupButton() {
        guard let viewModel = currViewModel else { return }
        payWallViewController?.showAlertView(title: "SKU", message: viewModel.sku)
    }


}

extension AuthCoordinator: PaywallViewDelegate {
    func userDidShakeDevice() {
        fetchLoginPreference()
    }

}
