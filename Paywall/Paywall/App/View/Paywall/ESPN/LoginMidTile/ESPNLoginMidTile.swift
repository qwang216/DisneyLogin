//
//  ESPNLoginMidTile.swift
//  Paywall
//
//  Created by Jason wang on 7/19/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

struct ESPNLoginMidTileViewModel {
    let title: String
    let subTitle: String
}

class ESPNLoginMidTile: UIView, NibableView {
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var subtittleLabel: UILabel!

    func config(_ viewModel: ESPNLoginMidTileViewModel) {
        tittleLabel.text = viewModel.title
        subtittleLabel.text = viewModel.subTitle
    }
}
