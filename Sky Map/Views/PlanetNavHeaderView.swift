//
//  PlanetNavHeaderView.swift
//  Sky Map
//
//  Created by Tom Bastable on 30/04/2024.
//

import SwiftUI

struct PlanetNavHeaderView: View {
    
    @Binding var showDetail: Bool
    
    var body: some View {
        HStack {
            
            Spacer()
            Button() {
                withAnimation {
                    showDetail.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .padding()
                    .background(.gray.opacity(0.3))
                    .clipShape(.circle)
                    .tint(.white)
            }
            .zIndex(2)
            .padding(.trailing, 15)
        }
    }
}

#Preview {
    PlanetNavHeaderView(showDetail: .constant(true))
}
