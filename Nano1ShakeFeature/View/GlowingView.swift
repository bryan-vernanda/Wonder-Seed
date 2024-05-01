//
//  GlowingView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 01/05/24.
//

import SwiftUI

struct GlowingView: View {
    var image: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .glow()
        }
    }
}

struct Glow: ViewModifier {
    @State private var throb: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: throb ? 15 : 5)
                .animation(.easeInOut(duration: 1).repeatForever(), value: throb)
                .onAppear {
                    throb.toggle()
                }
            
            content
        }
    }
}

extension View {
    func glow() -> some View {
        modifier(Glow())
    }
}

#Preview {
    GlowingView(image: "bucketPupuk")
}
