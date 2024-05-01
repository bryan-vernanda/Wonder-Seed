//
//  Vibrate.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 01/05/24.
//

import SwiftUI

struct Vibrate: View {
    @State private var start: Bool = false
    @State private var shakeTimer: Timer?
    var image: String

    var body: some View {
        VStack {
            Image("vibrateL")
                .font(Font.system(size: 50))
                .offset(x: start ? 20 : 0)
                .padding()
        }
        .onAppear {
            startShakeAnimation()
        }
    }

    private func startShakeAnimation() {
        shakeTimer?.invalidate()
        shakeTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            start = true
            withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                start = false
            }
        }
    }
}

#Preview {
    Vibrate(image: "vibrateL")
}
