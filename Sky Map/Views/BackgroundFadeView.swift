//
//  BackgroundFadeView.swift
//  Sky Map
//
//  Created by Tom Bastable on 30/04/2024.
//

import SwiftUI

struct BackgroundFadeView: View {
    
    @Binding var veilBackground: Bool
    
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.black)
            .opacity(veilBackground ? 0.6 : 0.0)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundFadeView(veilBackground: .constant(true))
}
