//
//  POIRow.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-27.
//

import SwiftUI

struct POIRow: View {
    let name: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.red)
                .background(Color.white.clipShape(Circle()))
                .shadow(radius: 3)

            Text(name)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

