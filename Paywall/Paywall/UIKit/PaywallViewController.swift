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

protocol DisneyLoginActionViewDelegate: AnyObject {
    func didTapLoginButton()
    func didTapSignupButton()
}

class DisneyLoginActionableView: UIView {
    weak var delegate: DisneyLoginActionViewDelegate?
    let signupButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("SIGN UP NOW", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .blue
        return bt
    }()

    let vStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .vertical
        vs.alignment = .fill
        return vs
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(vStack)
        vStack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        vStack.addArrangedSubview(signupButton)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class PaywallViewController: UIViewController {
    let splashImageView: UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let loginActionView: DisneyLoginActionableView = {
        let view = DisneyLoginActionableView(frame: .zero)
        view.backgroundColor = .green
        return view
    }()

    var payWallViewModel: PaywallViewModel? {
        didSet {
            updateUI()
        }
    }
    weak var delegate: PaywallViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConstrains()
    }

    private func setupViewConstrains() {
        view.addSubview(splashImageView)
        view.addSubview(loginActionView)
        splashImageView.fillToSuperview()
        loginActionView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 300))
    }

    func updateUI() {
        guard let viewModel = payWallViewModel else { return }
        let imageTask = splashImageView.fetchImage(urlPath: viewModel.splashImageURLString)
        imageTask?.resume()

//        splashImageView
        print(viewModel.freeTrailText)
        print(viewModel.brandsURLString)
        print(viewModel.logoURLString)
    }

    func didShake() {
        // TODO: Reload the paywall whenever the shake gesture occurs
        delegate?.userDidShakeDevice()
    }

}

extension PaywallViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            didShake()
        }
    }
}
