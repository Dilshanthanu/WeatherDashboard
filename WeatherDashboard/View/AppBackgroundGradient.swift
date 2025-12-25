//
//  AppBackgroundGradient.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-19.
//

import SwiftUI

struct AppBackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 0.78, green: 0.86, blue: 0.96), location: 0.0), 
                .init(color: Color(red: 0.86, green: 0.83, blue: 0.94), location: 0.35),
                .init(color: Color(red: 0.97, green: 0.86, blue: 0.82), location: 0.7),
                .init(color: Color(red: 0.92, green: 0.86, blue: 0.94), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
