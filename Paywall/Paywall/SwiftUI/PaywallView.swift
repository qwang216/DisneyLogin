//
//  ContentView.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming Services. All rights reserved.
//

import SwiftUI

struct PaywallView: View {
    var payWallViewModel: PaywallViewModel?
    var body: some View {
        Text("Hello, World!")
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification), perform: { _ in
                // TODO: handle shake to reload.
                // If you prefer to handle this in a different way
                // or in a different part of the code, feel free.
            })
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}
