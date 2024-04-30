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
    @State var progressBar:CGFloat = 0
    @State var imageIndicator: Int = 0
    @State var fertilizerProgress: CGFloat = 0
    @Environment (\.dismiss) var dismiss
    
    init() {
        gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gameScene.scaleMode = .fill
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .onReceive(gameScene.$progressBar, perform: { value in
                    self.progressBar = value
                })
                .onReceive(gameScene.$fertilizerProgress, perform: { value in
                    self.fertilizerProgress = value
                })
            
            WaterBar(current: $progressBar, width: 177, height: 16)
                .position(CGPoint(x: 130, y: 80))
//                .onChange(of: imageIndicator) {
//                    //declare image index 1
//                    if progressBar == 20 {
//                        // nanti disini switch imagenya, bikin pake zstack, opacity, with animation, delay
//                        imageIndicator = 1
//                    } else if fertilizerProgress == 20 {
//                        // anti disini switch imagenya, bikin pake zstack, opacity, with animation, delay
//                        imageIndicator = 2
//                    } else{
//                        // nanti disini bikin mataharinya
//                        imageIndicator = 3
//                    }
//                }

            
            fertilizerBar(current: $fertilizerProgress, width: 177, height: 16)
                .position(CGPoint(x: 130, y: 120))
            
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
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    plantingView()
}

//        @Environment(\.dismiss)  var dismiss
//        ZStack{
//
//
//            VStack(alignment: .leading){
//                Button(action: {
//                    dismiss()
//                    print("Success")
//                }) {
//                    Image(systemName: "chevron.backward.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(Color.P_700)
//                        .frame(width: 30, height: 30)
//                }.padding(27)
//                Rectangle()
//                    .foregroundColor(.white)
//                Rectangle()
//                    .foregroundColor(Color("grassColor"))
//                    .ignoresSafeArea()
//                    .frame(height: 255)
//
//            }
//            Image("bibit").resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 170, height: 250
//                )
//                .position(x: 190, y:500)
////                .position(x: UIScreen.main.bounds.width
////                          , y: UIScreen.main.bounds.height
////                )
//
//            .navigationBarBackButtonHidden()
//            .navigationBarBackButtonHidden()

//        }
