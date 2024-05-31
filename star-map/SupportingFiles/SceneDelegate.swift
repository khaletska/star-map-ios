//
//  SceneDelegate.swift
//  star-map
//
//  Created by Yeliena Khaletska on 31.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let viewController = RootViewController()
        window.rootViewController = viewController
        self.window = window

        window.makeKeyAndVisible()
    }

}
