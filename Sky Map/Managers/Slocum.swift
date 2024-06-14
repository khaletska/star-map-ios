//
//  Slocum.swift
//  Sky Map
//
//  Created by Tom Bastable on 27/04/2024.
//

import Foundation
import SwiftAA
import CoreLocation
import ARKit
import SceneKit

///named after Joshua Slocum - famous constellation navigator.
class Slocum {
    
    static let shared = Slocum()
    
    func arkitCoordinates(for object: CelestialObject) -> SCNVector3? {
        
        if let location = LocationManager.shared.getCurrentLocation() {
            
            let planetObject = object.celestialObject(date: date())
            
            let horizontalCoordinates = planetObject.makeHorizontalCoordinates(with: GeographicCoordinates(location))
            
            let azimuth = horizontalCoordinates.northBasedAzimuth.inRadians
            let altitude = horizontalCoordinates.altitude.inRadians
            
            let azimuthAsFloat = Float(azimuth.value)
            let altitudeAsFloat = Float(altitude.value)
            
            let coordinates = self.azimuthAltitudeToVector(azimuth: azimuthAsFloat, altitude: altitudeAsFloat)
            
            return coordinates
        } else {
            return nil
        }
    }
    
    func date() -> Date {
        
        let today = Date()
        
        let timeZone = TimeZone.current
        let calendar = Calendar.current
        
        var components = calendar.dateComponents(in: timeZone, from: today)
        components.timeZone = TimeZone(secondsFromGMT: -2 * 60 * 60)

        return calendar.date(from: components)!
        
    }
    
    func azimuthAltitudeToVector(azimuth: Float, altitude: Float, iss: Bool = false) -> SCNVector3 {

        let radius: Float = iss ? 408 : 10

        let x = radius * cos(altitude) * sin(azimuth)
        let y = radius * sin(altitude)
        let z = radius * cos(altitude) * cos(azimuth)
        
        return SCNVector3(x, y, -z)
    }
    
    func issArkitCoordinates(completion: @escaping (SCNVector3?) -> Void) {
        
        fetchISSLocation { coordinate, _ in
            
            if let coordinate, let location = LocationManager.shared.getCurrentLocation() {
                
                let azimuth = self.azimuthIss(data: coordinate, loc: location.coordinate)
                
                let vector = self.azimuthAltitudeToVector(azimuth: Float(azimuth.azimuth.radians),
                                                          altitude: Float(azimuth.elevation.radians),
                                                          iss: true)
                completion(vector)
            }
        }
    }
    
    func fetchISSLocation(completion: @escaping (SatteliteCoordinates?, Error?) -> Void) {
        
        let url = URL(string: "https://api.wheretheiss.at/v1/satellites/25544")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let latitude = json?["latitude"] as? Double,
                   let longitude = json?["longitude"] as? Double,
                   let altitude = json?["altitude"] as? Double {
                    
                    let coordinate = SatteliteCoordinates(lat: latitude, lon: longitude, alt: altitude)
                    completion(coordinate, nil)
                    
                } else {
                    completion(nil,
                               NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"]))
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func azimuthIss(data: SatteliteCoordinates, loc: CLLocationCoordinate2D) -> (azimuth: Double, elevation: Double) {
        
        let φ1 = loc.latitude.radians
        let λ1 = loc.longitude.radians
        let φ2 = data.lat.radians
        let λ2 = data.lon.radians
        
        let earthRadius: Double = 6371

        let ψ = atan2(sin(λ2 - λ1) * cos(φ2),
                      cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(λ2 - λ1))
        
        let azimuth = ψ * 180 / .pi
        //let correctedAzimuth = (azimuth < 0) ? azimuth + 360 : azimuth

        let rS = data.alt + earthRadius
        let γ = acos(sin(φ1) * sin(φ2) + cos(φ1) * cos(φ2) * cos(λ1 - λ2))
        let d = sqrt((1 + pow(earthRadius / rS, 2)) - 2 * (earthRadius / rS) * cos(γ))
        let elevation = acos(sin(γ) / d) * 180 / .pi * ((d > 0.34) ? -1 : 1)

        return (azimuth, elevation)
    }
}
