//
//  UIView+Extensions.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit


protocol NibableView {
    static func instanceFromNib() -> Self
}

extension NibableView where Self: UIView {
    static func instanceFromNib() -> Self {
        return UINib(nibName: String(describing: Self.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as! Self
    }
}

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
    func center(view: UIView, offSetX: CGFloat = 0, offSetY: CGFloat = 0) -> [NSLayoutConstraint] {
        anchor()
        let constraints =
            [centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offSetX),
             centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offSetY)]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

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
            let topConstraint = topAnchor.constraint(equalTo: top, constant: padding.top)
            anchor.top = topConstraint
        }
        if let leading = leading {
            let leadingConstraint = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            anchor.leading = leadingConstraint
        }
        if let bottom = bottom {
            let bottomConstraint = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
            anchor.bottom = bottomConstraint
        }
        if let trailing = trailing {
            let trailingConstraint = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
            anchor.trailing = trailingConstraint
        }
        if size.width != 0 {
            let widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
            anchor.width = widthConstraint
        }
        if size.height != 0 {
            let heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
            anchor.height = heightConstraint
        }
        let anchorConstraints = [anchor.top, anchor.bottom, anchor.leading, anchor.trailing, anchor.width, anchor.height].compactMap { $0 }
        NSLayoutConstraint.activate(anchorConstraints)
        return anchor
    }
}
