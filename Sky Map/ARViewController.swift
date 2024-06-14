//
//  ARView.swift
//  Sky Map
//
//  Created by Tom Bastable on 27/04/2024.
//

import SwiftUI
import ARKit
import CoreLocation

struct ARViewContainer: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel = ARViewModel.shared
    
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        let fadeAction = SCNAction.fadeOpacity(to: viewModel.passthrough ? 0.0 : 1.0, duration: 0.5)
        uiViewController.skyBox.runAction(fadeAction)
        
        if viewModel.loadObjects && !viewModel.hasLoaded {
            
            viewModel.hasLoaded = true
            uiViewController.setupSkybox()
            uiViewController.setupISS()
            uiViewController.addPlanets()
        }
    }
}

class ARViewController: UIViewController {
    
    var arView: ARSCNView!
    var skyBox: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arView = ARSCNView(frame: self.view.frame)
        skyBox = SCNScene(named: "Skybox.usdz")!.rootNode
        
        self.view.addSubview(arView)
        self.addTapGestureToSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        configuration.planeDetection = [.horizontal, .vertical]
        
        arView.session.run(configuration)
        addLightToScene(scene: arView.scene)
    }
}

//MARK: - Helpers
extension ARViewController {
    
    func makeNodeFaceCamera(node: SCNNode) {

        DispatchQueue.main.async {

            let constraint = SCNLookAtConstraint(target: self.arView.pointOfView)

            constraint.isGimbalLockEnabled = true

            node.constraints = [constraint]
        }
    }
    
    func addLightToScene(scene: SCNScene) {
        
        let lightNode = SCNNode()
        
        lightNode.light = SCNLight()
        lightNode.light?.type = .ambient
        lightNode.light?.color = UIColor.white
        lightNode.position = SCNVector3(x: 0, y: -300, z: 0)

        arView.scene.rootNode.addChildNode(lightNode)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let hitResults = arView.hitTest(gestureRecognizer.location(in: self.view),
                                        options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue])
        
        if let hit = hitResults.first {
            
            let name = hit.node.name ?? "No name"
            
            if let planet = CelestialObject(rawValue: name) {
                withAnimation {
                    ARViewModel.shared.object = planet
                    ARViewModel.shared.showDetail = true
                }
            }
        }
    }
    
}

//MARK: - Node Extension
extension ARViewController {
    
    func setupSkybox() {
        
        skyBox.scale = SCNVector3(1.5, 1.5, 1.5)
        skyBox.position = SCNVector3(x: 0, y: 0, z: 0)
        
        arView.scene.rootNode.addChildNode(skyBox)
        
    }
    
    func setupISS() {
        
        Slocum.shared.issArkitCoordinates { coordinates in
            
            if let coordinates {
                
                let iss = SCNScene(named: "ISS.usdz")!.rootNode
                
                iss.scale = SCNVector3(0.04, 0.04, 0.04)
                iss.position = coordinates
                self.arView.scene.rootNode.addChildNode(iss)
                
                self.addFixedText(to: iss, with: "ISS", in: self.arView)
                self.makeNodeFaceCamera(node: iss)
            }
        }
    }
    
    func addPlanets() {
        
        let planets = CelestialObject.allCases

        for planet in planets {
            
            if planet == .earth { continue }
            
            if let node = planet.loadModelNode() {
                
                node.position = Slocum.shared.arkitCoordinates(for: planet) ?? .init()
                arView.scene.rootNode.addChildNode(node)
                
                self.addFixedText(to: node, with: planet.rawValue, in: self.arView)
                self.makeNodeFaceCamera(node: node)
            }
        }
    }
    
    func addFixedText(to node: SCNNode, with text: String, in sceneView: ARSCNView) {

        let textGeometry = SCNText(string: text, extrusionDepth: 0.1)
        textGeometry.font = UIFont(name: "VisbyCF-Medium", size: 6)
        textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white

        let textNode = SCNNode(geometry: textGeometry)
        textNode.opacity = 0.6
        
        let (minBound, maxBound) = textGeometry.boundingBox
            textNode.pivot = SCNMatrix4MakeTranslation(
                (maxBound.x + minBound.x) / 2,
                (maxBound.y + minBound.y) / 2,
                (maxBound.z + minBound.z) / 2
            )

        
        textNode.scale = SCNVector3(0.05, 0.05, 0.05)

        textNode.position = SCNVector3(node.position.x, node.position.y - 0.35, node.position.z - 0.0)

        let billboardConstraint = SCNBillboardConstraint()
        textNode.constraints = [billboardConstraint]

        self.arView.scene.rootNode.addChildNode(textNode)
    }
    
}
