//
//  LoginPreference.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import Foundation

enum Theme: String, Decodable {
    case disney
    case espn
}

struct LoginPreference: Decodable {
    let theme: Theme
    let sku: String
    let subtexts: [String]
    let trialPromo: String
    let imageAssets: ImageAssets
}

extension LoginPreference {
    private enum CodingKeys: String, CodingKey {
        case theme, sku, subtexts
        case trialPromo = "trial-promo"
        case imageAssets = "image-assets"
    }

    struct ImageAssets: Decodable {
        let splash: String
        var brands: String?
        var logo: String?
    }
}
