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
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(Color.clear) 
        .cornerRadius(20)
        .shadow(radius: 6)
        .padding()
    }
}
