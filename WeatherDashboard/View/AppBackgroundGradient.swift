//
//  AppBackgroundGradient.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-19.
//

import SwiftUI

struct AppBackgroundGradient: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: gradientStops),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var gradientStops: [Gradient.Stop] {
        if colorScheme == .dark {
            return [
                .init(color: Color(red: 0.08, green: 0.12, blue: 0.18), location: 0.0),
                .init(color: Color(red: 0.12, green: 0.16, blue: 0.24), location: 0.4),
                .init(color: Color(red: 0.18, green: 0.14, blue: 0.22), location: 0.75),
                .init(color: Color(red: 0.10, green: 0.10, blue: 0.16), location: 1.0)
            ]
        } else {
            return [
                .init(color: Color(red: 0.78, green: 0.86, blue: 0.96), location: 0.0),
                .init(color: Color(red: 0.86, green: 0.83, blue: 0.94), location: 0.35),
                .init(color: Color(red: 0.97, green: 0.86, blue: 0.82), location: 0.7),
                .init(color: Color(red: 0.92, green: 0.86, blue: 0.94), location: 1.0)
            ]
        }
    }
}
