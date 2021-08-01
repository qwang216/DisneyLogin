//
//  PaywallViewModel.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import Foundation

protocol PaywallViewModelDelegate: AnyObject {
    func failedFetchingPreference(_ err: APIError)
    func didfinishFetchingPreference()
}

class PaywallViewModel {
    private let networkService: DisneyNetworkServiceable
    var preference: LoginPreference?
    weak var delegate: PaywallViewModelDelegate?

    init(networkService: DisneyNetworkServiceable) {
        self.networkService = networkService
    }

    func fetchLoginPreference() {
        networkService.getLoginPreference { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let preference):
                    self?.preference = preference
                    self?.delegate?.didfinishFetchingPreference()
                case .failure(let err):
                    self?.delegate?.failedFetchingPreference(err)
                }
            }
        }
    }

    var theme: Theme {
        return preference?.theme ?? .disney
    }

    var sku: String {
        return preference?.sku ?? "N/A"
    }

    var shouldFullScreenSplash: Bool {
        return preference?.theme == .espn
    }

    var freeTrailText: String {
        return preference?.trialPromo ?? "N/A"
    }

    var splashImageURLString: String {
        return preference?.imageAssets.splash ?? ""
    }

    var logoURLString: String? {
        return preference?.imageAssets.logo
    }

    var brandsURLString: String? {
        return preference?.imageAssets.brands
    }

}
