//
//  PlanetDataView.swift
//  Sky Map
//
//  Created by Tom Bastable on 30/04/2024.
//

import SwiftUI

struct PlanetDataView: View {
    
    @Binding var planet: CelestialObject
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    InfoCard(title: "Distance from Earth",
                             value: planet.distanceFromEarth)
                    InfoCard(title: "Diameter",
                             value: planet.diameter)
                    InfoCard(title: "Day Length",
                             value: planet.dayLength)
                    InfoCard(title: "Average Temperature",
                             value: planet.averageTemperature)
                }
                .padding()
            }
        }
}

struct InfoCard: View {
    
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.5))
            Text(value)
                .foregroundStyle(.orange)
        }
        .padding()
        .cornerRadius(10)
    }
}

#Preview {
    PlanetDataView(planet: .constant(.jupiter))
}
