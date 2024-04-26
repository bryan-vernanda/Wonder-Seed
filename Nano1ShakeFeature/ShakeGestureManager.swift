//
//  ShakeGestureManager.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 25/04/24.
//

import Foundation
import SwiftUI
import Combine
import UIKit
//Combine declares publishers to expose values that can change over time, and subscribers to receive those values from the publishers
//catch the Shake gesture with the UiKit, with the Combine framework we publish this event and get the combine published info in the SwiftUI view that is a subscriber.
let messagePublisher = PassthroughSubject<Void, Never>()

class ShakeViewController: UIViewController {
    override func motionBegan(_ motion: UIEvent.EventSubtype,
                              with event: UIEvent?) {
        guard motion == .motionShake else { return }
        messagePublisher.send()
        //vibrate() //need to use UIKit to make vibration when shake can be detected
    }
    
//    func vibrate() {
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//    }
    
}
struct ShakeViewRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) ->
    ShakeViewController {
        ShakeViewController()
    }
    func updateUIViewController(_ uiViewController: ShakeViewController,
                                context: Context) {
        
    }
}
