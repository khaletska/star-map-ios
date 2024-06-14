//
//  PlanetHeaderView.swift
//  Sky Map
//
//  Created by Tom Bastable on 30/04/2024.
//

import SwiftUI

struct PlanetTitleHeaderView: View {
    
    @Binding var planet: CelestialObject
    
    var body: some View {
        VStack {
            Text(planet.rawValue)
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)
            Text(planet.subtitle)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.orange)
            
        }
    }
}

#Preview {
    PlanetTitleHeaderView(planet: .constant(.earth))
}
