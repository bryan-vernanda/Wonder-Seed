//
//  SunKitUtil.swift
//  Wonder Seed
//
//  Created by Romi Fadhurohman Nabil on 02/05/24.
//

import Foundation
import SunKit
import CoreLocation
import CoreMotion

class SunKitUtil: ObservableObject{
    
    let motionManager = CMMotionManager()
    @Published var sunBoolCheck: Bool = false
    @Published var sunAzimuthCoordinate: Double = 0
    
    func initiateSun() {
        // Define the location coordinates for Indonesia (Jakarta)
        let indonesiaLocation = CLLocation(latitude: -6.2088, longitude: 106.8456)
        // Define the timezone for Indonesia
        let timeZoneIndonesia = TimeZone(identifier: "Asia/Jakarta") ?? .current
        
        // Initialize the Sun object with the Indonesia location and timezone
        var mySun = Sun(location: indonesiaLocation, timeZone: timeZoneIndonesia)
        
        // Set the current date
        let currentDate = Date()
        mySun.setDate(currentDate)
        self.sunAzimuthCoordinate = mySun.azimuth.degrees
    }
        
    // Function to check if phone's rotation matches the sun's azimuth
    func isPhoneFacingSun(tolerance: Double = 10.0) {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available.")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "")")
                return
            }
            
            let rotation = data.attitude.yaw * 180 / .pi
            let azimuthDifference = abs(self.sunAzimuthCoordinate - rotation)
            
            // Check if the azimuth difference is within the tolerance
            if azimuthDifference <= tolerance {
                // Phone's rotation matches the sun's azimuth
                print("Phone is facing the sun!")
                self.sunBoolCheck = true
            } else {
                // Phone's rotation does not match the sun's azimuth
//                print("Phone is not facing the sun.")
                self.sunBoolCheck = false
            }
        }
    }
}
