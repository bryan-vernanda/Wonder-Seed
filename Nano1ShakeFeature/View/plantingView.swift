//
//  plantingView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import SwiftUI
import SpriteKit

struct plantingView: View {
    var gameScene: GameScene
    var sunkitUI: SunKitUtil
    @State var progressBar:CGFloat = 0
    @State var fertilizerProgress: CGFloat = 0
    @State var navigateToAchivementComplete: Bool = false
    @Environment (\.dismiss) var dismiss
    @State private var xOffsetSun: CGFloat = 0
    @State private var yOffsetSun: CGFloat = 0
    @State private var isImageVisible = true
    @State private var imageString = "questionIcon"

    
    init() {
        gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gameScene.scaleMode = .fill
        
        sunkitUI = SunKitUtil()
    }
    
    var body: some View {
        VStack {
            ZStack {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
                    .onReceive(gameScene.$progressBar, perform: { value in
                        self.progressBar = value
                    })
                    .onReceive(gameScene.$fertilizerProgress, perform: { value in
                        self.fertilizerProgress = value
                    })
                    .onReceive(gameScene.$statusDirectPage, perform: { value in
                        self.navigateToAchivementComplete = value
                    })
                //nanti pagi benerin lagi, soalnya gabisa cobain sun nya sekarang, nanti tolong bikin kalo misal matahari blm gerak, gabisa diapa-apain sprite viewnya, harusnya pake on recieve si sun nya aja deh
                
                Image("sun").position(CGPoint(x: 380, y: 80))
                    .offset(x: xOffsetSun, y: yOffsetSun)
                    .onReceive(sunkitUI.$sunBoolCheck, perform: { value in
                        if sunkitUI.sunBoolCheck {
                            withAnimation(.easeInOut(duration: 1)) {
                                xOffsetSun = -180
                                yOffsetSun = -100
                            }
                        }
                        
                    })
                    
                WaterBar(current: $progressBar, width: 177, height: 16)
                    .position(CGPoint(x: 130, y: 80))
                
                fertilizerBar(current: $fertilizerProgress, width: 177, height: 16)
                    .position(CGPoint(x: 130, y: 120))
                
                Image("sunIcon")
                    .position(CGPoint(x: 53, y: 165))
                
                VStack {
                    Image(imageString)
                        .opacity(isImageVisible ? 1 : 0)
                        .scaleEffect(isImageVisible ? 1 : 1.2)
                        .onAppear {
                            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true)) {
                                isImageVisible.toggle()
                            }
                        }
                        .onDisappear {
                            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.5).repeatForever(autoreverses: true)) {
                                isImageVisible.toggle()
                            }
                        }
                        .onReceive(sunkitUI.$sunBoolCheck, perform: { value in
                            if sunkitUI.sunBoolCheck {
                                imageString = "checkBox"
                            }
                        })
                }
                .position(CGPoint(x: 90, y: 165))
                //bungkus vstack buat ganti position parentnya
                
                Button(action: {
                    dismiss()
                    print("Success")
                }) {
                    Image(systemName: "chevron.backward.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color("P-700"))
                        .frame(width: 30, height: 30)
                }.position(CGPoint(x: 50, y: 20))
            }
            .navigationDestination(isPresented: $navigateToAchivementComplete){
                AchivementView(checkImage: true)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear(){
            sunkitUI.initiateSun()
            sunkitUI.isPhoneFacingSun()
        }
    }
}

#Preview {
    plantingView()
}
