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
            gradient: Gradient(colors: [
                Color(red: 0.35, green: 0.50, blue: 0.86),
                Color(red: 0.24, green: 0.37, blue: 0.66),
                Color(red: 0.17, green: 0.25, blue: 0.55)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

    }
}
