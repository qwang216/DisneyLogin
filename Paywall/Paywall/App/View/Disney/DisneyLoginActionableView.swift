//
//  DisneyLoginActionableView.swift
//  Paywall
//
//  Created by Jason wang on 7/19/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

protocol LoginFlowViewDelegate: AnyObject {
    func didTapLoginButton()
    func didTapSignupButton()
}

protocol LoginActionableView: UIView {
    var delegate: LoginFlowViewDelegate? { get set }
    func config(trailText: String)
}

class DisneyLoginActionableView: UIView, LoginActionableView, NibableView {
    weak var delegate: LoginFlowViewDelegate?
    @IBOutlet weak var startTrailLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#function)
    }

    @IBAction func signupButtonTapped(_ sender: UIButton) {
        delegate?.didTapSignupButton()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate?.didTapLoginButton()
    }

    func config(trailText: String) {
        startTrailLabel.text = trailText
    }
}
