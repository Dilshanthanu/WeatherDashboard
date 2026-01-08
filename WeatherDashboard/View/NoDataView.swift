//
//  NoDataView.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-31.
//

import SwiftUI

struct NoDataView: View {
    let title: String
    let message: String
    let systemImage: String

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 50))
                .foregroundColor(.purple)

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color.white.opacity(
                        colorScheme == .dark ? 0.08 : 0.15
                    )
                )
        )
        .shadow(
            color: .black.opacity(
                colorScheme == .dark ? 0.45 : 0.15
            ),
            radius: 6,
            y: 4
        )
        .padding()
    }
}
