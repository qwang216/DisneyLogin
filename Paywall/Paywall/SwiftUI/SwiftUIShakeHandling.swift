//
//  SwiftUIShakeHandling.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming Services. All rights reserved.
//

import SwiftUI

// The code in this file is designed to make it simple to implement the shake to reload code in SwiftUI.
// This is by no means the only way to accomplish this and it is not required that you use this code.
// It is provided as a helper and you should feel free to modify or ignore if you prefer a different approach.

extension Notification.Name {
  public static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}

extension UIWindow {
  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    super.motionEnded(motion, with: event)
    if motion == .motionShake {
      NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
  }
}
