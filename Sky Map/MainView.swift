//
//  ContentView.swift
//  Sky Map
//
//  Created by Tom Bastable on 27/04/2024.
//

import SwiftUI
import SceneKit

struct MainView: View {
    
    @ObservedObject var viewModel = ARViewModel.shared
    
    var body: some View {

        ZStack {
            
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                    LocationManager.shared.requestLocationAuthorization()
                })
            
            HeaderView(passthrough: $viewModel.passthrough)
            
            BackgroundFadeView(veilBackground: $viewModel.showDetail)
            
            VStack {
                
                ZStack {
                    
                    PlanetTitleHeaderView(planet: $viewModel.object)
                        .offset(y: -20)
                    
                    SceneKitContainerView(planet: $viewModel.object)
                        .frame(height: 300)
                        .offset(y: 150)
                        .zIndex(1)
                    
                    PlanetNavHeaderView(showDetail: $viewModel.showDetail)
                        .offset(y: -40)
                    
                }
                .zIndex(1)

                VStack {
                    
                    PlanetDataView(planet: $viewModel.object)
                        .offset(y: 100)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.customDarkGray)
                .clipShape(.rect(cornerRadius: 20))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.clear)
            .offset(y: viewModel.showDetail ? 0 : 1000)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    MainView()
}
