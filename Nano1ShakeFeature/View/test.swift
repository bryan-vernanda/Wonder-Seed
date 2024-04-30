//
//  test.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 30/04/24.
//

import SwiftUI

struct test: View {
    var imageNames: [String] = ["bucketPupuk", "air"]
    @State var indicator:Bool = true
    var body: some View {
        AnimatedImage(indicator: $indicator, imageNames: imageNames)
    }
}

#Preview {
    test()
}
