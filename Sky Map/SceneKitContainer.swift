//
//  SceneKitContainer.swift
//  Sky Map
//
//  Created by Tom Bastable on 29/04/2024.
//

import Foundation
import SceneKit
import SwiftUI

struct SceneKitContainerView: UIViewRepresentable {
    
    @Binding var planet: CelestialObject
    
    func makeUIView(context: Context) -> SCNView {

        let sceneView = SCNView()

        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = false
        sceneView.backgroundColor = UIColor.clear

        setupScene(sceneView: sceneView)

        return sceneView
    }
    
    func setupScene(sceneView: SCNView) {
        
        if let scene = try? SCNScene(url: Bundle.main.url(forResource: planet.rawValue, withExtension: "usdz")!, options: nil) {
            sceneView.scene = scene

            if let objectNode = scene.rootNode.childNodes.first {
                let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 10))
                objectNode.runAction(rotateAction)
            }

            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .directional
            lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
            lightNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
            lightNode.light?.color = UIColor.white
            scene.rootNode.addChildNode(lightNode)
            
            let fillLightNode = SCNNode()
            fillLightNode.light = SCNLight()
            fillLightNode.light?.type = .directional
            fillLightNode.light?.intensity = 50
            fillLightNode.position = SCNVector3(x: 0, y: -5, z: 0)
            scene.rootNode.addChildNode(fillLightNode)
        }
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        setupScene(sceneView: uiView)
    }
}
