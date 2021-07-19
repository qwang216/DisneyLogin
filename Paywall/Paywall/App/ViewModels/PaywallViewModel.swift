//
//  PaywallViewModel.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import Foundation

struct PaywallViewModel {
    private let preference: LoginPreference

    init(preference: LoginPreference) {
        self.preference = preference
    }

    var freeTrailText: String {
        return preference.trialPromo
    }

    var splashImageURLString: String {
        return preference.imageAssets.splash
    }

    var logoURLString: String? {
        return preference.imageAssets.logo
    }

    var brandsURLString: String? {
        return preference.imageAssets.brands
    }

}
