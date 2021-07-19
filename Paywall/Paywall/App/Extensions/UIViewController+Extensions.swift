//
//  UIViewController+Extensions.swift
//  Paywall
//
//  Created by Jason wang on 7/19/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Close",style: .cancel, handler: nil)
        alertView.addAction(reloadAction)
        present(alertView, animated: true, completion: nil)
    }
}
