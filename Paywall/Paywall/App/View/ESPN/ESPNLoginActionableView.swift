//
//  ESPNLoginActionableView.swift
//  Paywall
//
//  Created by Jason wang on 7/19/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

class ESPNLoginActionableView: UIView, LoginActionableView, NibableView {
    weak var delegate: LoginFlowViewDelegate?
    @IBOutlet weak var freeTrialLabel: UILabel!

    @IBAction func loginButonTapped(_ sender: UIButton) {
        delegate?.didTapLoginButton()
    }

    @IBAction func signupButtonTapped(_ sender: UIButton) {
        delegate?.didTapSignupButton()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

    func config(trailText: String) {
        self.freeTrialLabel.text = trailText
    }

}
