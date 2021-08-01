//
//  AuthCoordinator.swift
//  Paywall
//
//  Created by Jason wang on 7/29/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

class AuthCoordinator {

    let navigationController: UINavigationController
    let networkService: DisneyNetworkServiceable
    init(navController: UINavigationController, service: DisneyNetworkServiceable) {
        self.navigationController = navController
        self.networkService = service
    }

    private var payWallViewController: PaywallViewController?
    private var currViewModel: PaywallViewModel?
    var loginableView: LoginActionableView?

    func start() {
        payWallViewController = PaywallViewController()
        payWallViewController?.modalPresentationStyle = .fullScreen
        payWallViewController?.payWallViewModel = PaywallViewModel(networkService: networkService)
        navigationController.topViewController?.present(payWallViewController!, animated: true, completion: nil)
    }
}
