//
//  SplashView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 27/04/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
//            Text("DogSOS")
//                .font(.system(size: 55, weight: .bold, design: .default))
//                .foregroundColor(.black)
            Image("SeedSplash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive, content: {
            ContentView()
        })
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
}

struct SplashView_Preview: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
