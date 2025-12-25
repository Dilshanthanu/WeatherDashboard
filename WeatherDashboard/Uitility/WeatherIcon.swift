//
//  WeatherIcon.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-23.
//

import Foundation

extension Weather {

    var SymbolName: String {
        switch main.lowercased() {
        case "clear":
            return "sun.max.fill"

        case "clouds":
            return "cloud.fill"

        case "rain":
            return "cloud.rain.fill"

        case "drizzle":
            return "cloud.drizzle.fill"

        case "thunderstorm":
            return "cloud.bolt.rain.fill"

        case "snow":
            return "snowflake"

        case "mist", "fog", "haze", "smoke":
            return "cloud.fog.fill"

        default:
            return "questionmark.circle"
        }
    }
}

extension String {
    var camelCase: String {
        let words = self
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        guard let first = words.first else { return "" }

        let rest = words.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }
}
