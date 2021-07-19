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

    var loginActionableView: UIView = UIView()

    var payWallViewModel: PaywallViewModel? {
        didSet {
            updateUI()
        }
    }
    weak var shakeDelegate: PaywallViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashImageView)
        updateUI()
    }

    func updateUI() {
        guard let viewModel = payWallViewModel else {
            shouldHideView(true)
            return
        }
        shouldHideView(false)
        view.addSubview(loginActionableView)
        let loginActionHeight = view.frame.height * 0.33
        let deltaPercent = view.frame.height * 0.04
        let sidePadding: CGFloat = viewModel.shouldFullScreenSplash ? 30 : 0
        loginActionableView.anchor(leading: view.leadingAnchor,
                               bottom: view.bottomAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: 0, left: sidePadding, bottom: 0, right: sidePadding),
                               size: .init(width: 0, height: loginActionHeight))
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
        let imageTask = splashImageView.fetchImage(urlPath: viewModel.splashImageURLString, imageCacher: nil)
        imageTask?.resume()
        view.layoutIfNeeded()
    }

    private func shouldHideView(_ shouldHide: Bool) {
        splashImageView.isHidden = shouldHide
        loginActionableView.isHidden = shouldHide
    }

    func didShake() {
        shakeDelegate?.userDidShakeDevice()
    }

}

extension PaywallViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            didShake()
        }
    }
}
