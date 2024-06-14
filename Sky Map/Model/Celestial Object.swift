//
//  Celestial Object.swift
//  Sky Map
//
//  Created by Tom Bastable on 29/04/2024.
//

import Foundation
import SwiftAA
import ARKit

enum CelestialObject: String, CaseIterable {
    
    case jupiter = "Jupiter"
    case mercury = "Mercury"
    case neptune = "Neptune"
    case moon = "Moon"
    case saturn = "Saturn"
    case sun = "Sun"
    case uranus = "Uranus"
    case venus = "Venus"
    case mars = "Mars"
    case earth = "Earth"
    
    var subtitle: String {
        switch self {
        case .jupiter:
            return "Gas Giant"
        case .mercury:
            return "Swift Planet"
        case .neptune:
            return "Windy Ice Giant"
        case .moon:
            return "Earth's Satellite"
        case .saturn:
            return "Ringed Beauty"
        case .sun:
            return "Solar Luminary"
        case .uranus:
            return "Tilted Giant"
        case .venus:
            return "Veiled Planet"
        case .mars:
            return "The Red Planet"
        case .earth:
            return "Blue Home"
        }
    }
    
    var distanceFromEarth: String {
        switch self {
        case .mercury: return "77.0 million km"
        case .venus: return "41.4 million km"
        case .earth: return "0 km (Earth)"
        case .mars: return "78.3 million km"
        case .jupiter: return "628.7 million km"
        case .saturn: return "1,275 million km"
        case .uranus: return "2,724 million km"
        case .neptune: return "4,351 million km"
        case .moon: return "384,400 km"
        case .sun: return "149.6 million km"
        }
    }
    
    var diameter: String {
        switch self {
        case .mercury: return "4,879 km"
        case .venus: return "12,104 km"
        case .earth: return "12,742 km"
        case .mars: return "6,779 km"
        case .jupiter: return "139,820 km"
        case .saturn: return "116,460 km"
        case .uranus: return "50,724 km"
        case .neptune: return "49,244 km"
        case .moon: return "3,474 km"
        case .sun: return "1,392,700 km"
        }
    }
    
    var dayLength: String {
        switch self {
        case .mercury: return "1,407.6 hours"
        case .venus: return "5,832.5 hours"
        case .earth: return "24 hours"
        case .mars: return "24.6 hours"
        case .jupiter: return "9.9 hours"
        case .saturn: return "10.7 hours"
        case .uranus: return "17.2 hours"
        case .neptune: return "16.1 hours"
        case .moon: return "708.7 hours"
        case .sun: return "609.1 hours (equatorial rotation)"
        }
    }
    
    var averageTemperature: String {
        switch self {
        case .mercury: return "167°C"
        case .venus: return "464°C"
        case .earth: return "15°C"
        case .mars: return "-65°C"
        case .jupiter: return "-110°C"
        case .saturn: return "-140°C"
        case .uranus: return "-195°C"
        case .neptune: return "-200°C"
        case .moon: return "-20°C"
        case .sun: return "5,505°C"
        }
    }
    
    func celestialObject(date: Date) -> CelestialBody {
        let jd = JulianDay(date)
        switch self {
        case .mercury:
            return Mercury(julianDay: jd)
        case .venus:
            return Venus(julianDay: jd)
        case .mars:
            return Mars(julianDay: jd)
        case .jupiter:
            return Jupiter(julianDay: jd)
        case .saturn:
            return Saturn(julianDay: jd)
        case .uranus:
            return Uranus(julianDay: jd)
        case .neptune:
            return Neptune(julianDay: jd)
        case .sun:
            return Sun(julianDay: jd)
        case .moon:
            return Moon(julianDay: jd)
        default:
            return Moon(julianDay: jd)
        }
    }
    
    private var relativeSize: Float {
        switch self {
        case .sun: return 109.0
        case .jupiter: return 10.0
        case .saturn: return 9.0
        case .uranus: return 4.0
        case .neptune: return 3.9
        case .earth: return 1.0
        case .venus: return 0.95
        case .mars: return 0.53
        case .mercury: return 0.38
        case .moon: return 0.27
        }
    }

    private var normalizedSize: Float {
        switch self {
        case .sun: return 1.0
        case .jupiter: return 0.1
        case .saturn: return 0.083
        case .uranus: return 0.036
        case .neptune: return 0.035
        case .earth: return 0.009157
        case .venus: return 0.008848
        case .mars: return 0.0048
        case .mercury: return 0.00384
        case .moon: return 0.25
        }
    }
    
    var scale: SCNVector3 {

        let maxScale = SCNVector3(0.006, 0.006, 0.006)
        let minScale = SCNVector3(0.001, 0.001, 0.001)

        let normalizedSize = (self.normalizedSize - CelestialObject.mercury.normalizedSize) /
        (CelestialObject.sun.normalizedSize - CelestialObject.mercury.normalizedSize)

        let scaleValue = minScale.x + normalizedSize * (maxScale.x - minScale.x)

        return SCNVector3(scaleValue, scaleValue, scaleValue)
    }

    var scaledSize: Float {

        let minScale: Float = 0.2
        let maxScale: Float = 0.5

        return minScale + (normalizedSize * (maxScale - minScale))
    }
    
    func modelFileName() -> String {
        return self.rawValue + ".usdz"
    }
    
    func loadModelNode() -> SCNNode? {
        
        guard let scene = SCNScene(named: "\(self.rawValue).scn") else {
            fatalError("Unable to load the scene file.")
        }
        
        let wrapperNode = SCNNode()
        for child: SCNNode in scene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        wrapperNode.scale = scale
        return wrapperNode
    }
}
