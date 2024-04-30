//
//  AnimatedImage.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 30/04/24.
//

import SwiftUI

struct AnimatedImage: View {
    
    @State private var image: Image = Image("")
    @Binding var indicator: Bool
    var imageNames: [String]
    @State var imageIndex: Int = 0
    
    var body: some View {
        Group {
            image
                .resizable()
                .scaledToFit()
        }.onAppear(perform: {
            self.animate()
        })
    }
    
    private func animate() {
        if (indicator) {
            if imageIndex < self.imageNames.count {
                self.image = Image(self.imageNames[imageIndex])
                imageIndex += 1
            }
        }
    }
}
