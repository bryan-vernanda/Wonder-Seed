//
//  ContentView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 25/04/24.
//

import SwiftUI
import AVFoundation
import SpriteKit

struct ContentView: View {
    @State var shaked = false
    @State var count:Int = 0
    @State var indicator = false
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        ZStack {
                            //ShakeViewRepresentable that can’t get touch event from the user because allowsHitTesting is false
                            ShakeViewRepresentable()
                                .allowsHitTesting(false)
                            VStack {
                                Image("Jar")
                            }
                        }.onReceive(messagePublisher) { _ in
                            self.shaked = true
                            self.playRingtone()
                        }.shake($shaked) {
                            count += 1
                            if(count == 3) {
                                self.indicator = true
                            }
                        }
                    }
                }
                .frame(width: 330, height: 330)
                .navigationDestination(isPresented: $indicator){
                    plantingView()
                }
                
                
                VStack {
                    Spacer()
                    NavigationLink(
                        destination: AchivementView(checkImage: false),
                        label: {
                            Image("SeedNavLogo")
                        }
                    )
                }
                .frame(width: 80, height: 80)
                .position(x: UIScreen.main.bounds.width - 70, y: UIScreen.main.bounds.height - 170)
                
                Vibrate(image: "vibrateL")
                    .position(x: 40, y: 380)
                    .rotationEffect(.degrees(180))
                Vibrate(image: "vibrateR")
                    .position(x: 40, y: 380)
            }
        }
    }
    
    func playRingtone() {
        guard let url = Bundle.main.url(forResource: "ringtone", withExtension: "mp3") else {
            print("Failed to find ringtone file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play ringtone: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
