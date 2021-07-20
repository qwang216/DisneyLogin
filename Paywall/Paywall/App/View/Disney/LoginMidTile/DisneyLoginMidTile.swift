//
//  DisneyLoginMidTile.swift
//  Paywall
//
//  Created by Jason wang on 7/19/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

struct DisneyMidTileViewModel {
    let mainLogoURL: String
    let quote: String
    let brandsURL: String
}

class DisneyLoginMidTile: UIView, NibableView {
    @IBOutlet weak var mainLogoImageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var brandsImageView: UIImageView!

    func config(_ midTileViewModel: DisneyMidTileViewModel) {
        let logoImageTask = mainLogoImageView.fetchImage(urlPath: midTileViewModel.mainLogoURL)
        quoteLabel.text = midTileViewModel.quote
        let brandsImageTask = brandsImageView.fetchImage(urlPath: midTileViewModel.brandsURL)
        [logoImageTask, brandsImageTask].forEach { $0?.resume() }
    }

}
