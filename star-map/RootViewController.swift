//
//  RootViewController.swift
//  star-map
//
//  Created by Yeliena Khaletska on 31.05.2024.
//

import UIKit
import RealityKit
import ARKit
import OSLog

final class RootViewController: UIViewController {

    // MARK: - Properties -
    private let augmentedRealityView: ARView
    private let skyBox: Entity
    private let logger = Logger(subsystem: "com.star-map", category: "RootViewController")

    // MARK: - Init -

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.augmentedRealityView = ARView(frame: .zero)
        self.skyBox = try! Entity.load(named: "Skybox")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setupViews()
        setupScene()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopSession()
    }

    // MARK: - Private API -

    private func setupViews() {
        self.augmentedRealityView.frame = self.view.bounds
        self.view.addSubview(self.augmentedRealityView)
    }

    private func setupScene() {
        self.skyBox.scale = [1.5, 1.5, 1.5]
        self.skyBox.position = [0, 0, 0]

        let anchor = AnchorEntity(world: [0, 0, 0])
        anchor.addChild(self.skyBox)
        self.augmentedRealityView.scene.addAnchor(anchor)
        self.logger.log("Scene setup completed.")
    }

    private func startSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        configuration.isLightEstimationEnabled = true
        configuration.worldAlignment = .gravity
        configuration.frameSemantics.insert(.personSegmentation)

        self.augmentedRealityView.session.run(configuration)
        self.logger.log("Augmented Reality session started.")
    }

    private func stopSession() {
        self.augmentedRealityView.session.pause()
        self.logger.log("Augmented Reality session stopped.")
    }
}
