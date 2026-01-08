//
//  POIRow.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-27.
//

import SwiftUI

struct POIRow: View {
    let name: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.red)
                .padding(6)
                .background(
                    Color.white.opacity(
                        colorScheme == .dark ? 0.1 : 0.9
                    )
                )
                .clipShape(Circle())
                .shadow(
                    color: .black.opacity(
                        colorScheme == .dark ? 0.4 : 0.15
                    ),
                    radius: 3
                )

            Text(name)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}
