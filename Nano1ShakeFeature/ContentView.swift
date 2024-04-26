//
//  ContentView.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 25/04/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var shaked = false
    @State var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    //ShakeViewRepresentable that can’t get touch event from the user because allowsHitTesting is false
                    ShakeViewRepresentable()
                        .allowsHitTesting(false)
                    VStack {
                        Text("Shake device to change view!")
                    }
                    
                }.onReceive(messagePublisher) { _ in
                    self.shaked = true
                    self.playRingtone()
                }
            }
            .navigationDestination(isPresented: $shaked){
                SecondView()
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
