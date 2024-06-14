//
//  HeaderView.swift
//  Sky Map
//
//  Created by Tom Bastable on 30/04/2024.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var passthrough: Bool
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button() {
                    withAnimation {
                        passthrough.toggle()
                    }
                } label: {
                    Image(systemName: "cube.transparent")
                        .padding()
                        .background(.gray.opacity(0.3))
                        .clipShape(.circle)
                        .tint(.white)
                }
                .padding(.trailing, 15)
            }
            Spacer()
        }
    }
}

#Preview {
    HeaderView(passthrough: .constant(true))
}
