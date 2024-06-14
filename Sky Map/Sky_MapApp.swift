//
//  Sky_MapApp.swift
//  Sky Map
//
//  Created by Tom Bastable on 27/04/2024.
//

import SwiftUI

@main
struct Sky_MapApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class ARViewModel: ObservableObject {
    static let shared = ARViewModel()
    @Published var showDetail: Bool = false
    @Published var object: CelestialObject = .jupiter
    @Published var passthrough: Bool = false
    @Published var loadObjects: Bool = false
    @Published var hasLoaded: Bool = false
}
