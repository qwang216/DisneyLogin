//
//  UIView+Extensions.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

struct Anchor {
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var leading: NSLayoutConstraint?
    var trailing: NSLayoutConstraint?
    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?
}

extension UIView {

    @discardableResult
    func fillToSuperview(padding: UIEdgeInsets = .zero) -> Anchor? {
        return anchor(top: superview?.topAnchor,
                      leading: superview?.leadingAnchor,
                      bottom: superview?.bottomAnchor,
                      trailing: superview?.trailingAnchor,
                      padding: padding)
    }

    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> Anchor? {

        translatesAutoresizingMaskIntoConstraints = false
        var anchor = Anchor()
        if let top = top {
            let topConstrain = topAnchor.constraint(equalTo: top, constant: padding.top)
            anchor.top = topConstrain
        }
        if let leading = leading {
            let leadingConstrain = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            anchor.leading = leadingConstrain
        }
        if let bottom = bottom {
            let bottomConstrain = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
            anchor.bottom = bottomConstrain
        }
        if let trailing = trailing {
            let trailingConstrain = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
            anchor.trailing = trailingConstrain
        }
        if size.width != 0 {
            let widthConstrain = widthAnchor.constraint(equalToConstant: size.width)
            anchor.width = widthConstrain
        }
        if size.height != 0 {
            let heightConstrain = heightAnchor.constraint(equalToConstant: size.height)
            anchor.height = heightConstrain
        }
        let anchorConstrains = [anchor.top, anchor.bottom, anchor.leading, anchor.trailing, anchor.width, anchor.height].compactMap { $0 }
        NSLayoutConstraint.activate(anchorConstrains)
        return anchor
    }
}
