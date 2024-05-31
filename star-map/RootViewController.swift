//
//  RootViewController.swift
//  star-map
//
//  Created by Yeliena Khaletska on 31.05.2024.
//

import UIKit
import ARKit

final class RootViewController: UIViewController {

    // MARK: - Properties -

    private let augmentedRealityView: ARSCNView

    // MARK: - Init -

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.augmentedRealityView = .init(frame: .zero)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemOrange
    }

    // MARK: - Private API -

    private func setupViews() {
        self.augmentedRealityView.frame = self.view.bounds
        self.augmentedRealityView.backgroundColor = .systemRed
        self.view.addSubview(self.augmentedRealityView)
    }

}
