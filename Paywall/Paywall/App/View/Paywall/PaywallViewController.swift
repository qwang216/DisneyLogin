//
//  PaywallViewController.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming Services. All rights reserved.
//

import UIKit

protocol PaywallViewDelegate: AnyObject {
    func userDidShakeDevice()
}

class PaywallViewController: UIViewController {
    let splashImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    var midTileView = UIView()
    var loginActionableView = UIView()

    var payWallViewModel: PaywallViewModel?
    weak var shakeDelegate: PaywallViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(splashImageView)
        payWallViewModel?.delegate = self
        payWallViewModel?.fetchLoginPreference()
    }

    private func configLoginableView(paywallVC: PaywallViewController, theme: Theme) {
        paywallVC.loginActionableView.removeFromSuperview()

        switch theme {
        case .disney:
            let loginableView = DisneyLoginActionableView.instanceFromNib()
            loginActionableView = loginableView
            loginableView.delegate = self
        case .espn:
            let loginableView = ESPNLoginActionableView.instanceFromNib()
            loginActionableView = loginableView
            loginableView.delegate = self
        }
    }

    private func configMidTileViewOn(paywallVC: PaywallViewController, preference: LoginPreference) {
        paywallVC.midTileView.removeFromSuperview()
        switch preference.theme {
        case .disney:
            let midTile = DisneyLoginMidTile.instanceFromNib()
            if let logoURL = preference.imageAssets.logo,
               let brandsURL = preference.imageAssets.brands,
               let quote = preference.subtexts.first {
                midTile.config(DisneyMidTileViewModel(mainLogoURL: logoURL, quote: quote, brandsURL: brandsURL))
            }
            paywallVC.midTileView = midTile
        case .espn:
            let midTile = ESPNLoginMidTile.instanceFromNib()
            if preference.subtexts.count == 2,
               let title = preference.subtexts.first,
               let subtitle = preference.subtexts.last {
                midTile.config(ESPNLoginMidTileViewModel(title: title, subTitle: subtitle))
            }
            paywallVC.midTileView = midTile
        }

    }


    func updateUI() {
        guard let viewModel = payWallViewModel else {
            shouldHideView(true)
            return
        }
        if let preference = viewModel.preference {
            configMidTileViewOn(paywallVC: self, preference: preference)
            configLoginableView(paywallVC: self, theme: preference.theme)
        }


        shouldHideView(false)
        view.addSubview(loginActionableView)
        view.addSubview(midTileView)
        let loginActionHeight = view.frame.height * 0.33
        let deltaPercent = view.frame.height * 0.04
        let sidePadding: CGFloat = viewModel.shouldFullScreenSplash ? 30 : 0

        loginActionableView.anchor(leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: .init(top: 0, left: sidePadding, bottom: 0, right: sidePadding),
                                   size: .init(width: 0, height: loginActionHeight))
        midTileView.anchor(leading: view.leadingAnchor,
                           bottom: loginActionableView.topAnchor,
                           trailing: view.trailingAnchor,
                           padding: .init(top: 20, left: 20, bottom: 20, right: 20),
                           size: .init(width: 0, height: loginActionHeight))
        midTileView.backgroundColor = .clear
        view.backgroundColor = viewModel.shouldFullScreenSplash ? .black : UIColor(red: 0.100565, green: 0.113202, blue: 0.160653, alpha: 1)
        let bottomConstant: CGFloat = viewModel.shouldFullScreenSplash ? 0 : loginActionHeight + deltaPercent
        splashImageView.contentMode = viewModel.shouldFullScreenSplash ? .scaleAspectFill : .scaleToFill
        splashImageView.anchor(top: view.topAnchor,
                               leading: view.leadingAnchor,
                               bottom: view.bottomAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 0,
                                              left: 0,
                                              bottom: bottomConstant,
                                              right: 0))
        splashImageView.fetchImage(urlPath: viewModel.splashImageURLString, imageCacher: nil)?.resume()
    }

    private func shouldHideView(_ shouldHide: Bool) {
        splashImageView.isHidden = shouldHide
        loginActionableView.isHidden = shouldHide
        midTileView.isHidden = shouldHide
    }

    func didShake() {
        payWallViewModel?.fetchLoginPreference()
    }

}

extension PaywallViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            didShake()
        }
    }
}

extension PaywallViewController: PaywallViewModelDelegate {
    func failedFetchingPreference(_ err: APIError) {
        // alert
        showAlertView(title: "Sorry Something Went wrong", message: err.errorDescription ?? "Network Error")
    }
    func didfinishFetchingPreference() {
        updateUI()
    }
}

extension PaywallViewController: LoginFlowViewDelegate {
    func didTapLoginButton() {
        showAlertView(title: "Log In", message: "")
    }

    func didTapSignupButton() {
        showAlertView(title: "SKU", message: payWallViewModel?.sku ?? "N/A")
    }


}
