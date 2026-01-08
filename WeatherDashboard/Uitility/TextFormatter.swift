//
//  TextFormatter.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2026-01-08.
//

import Foundation

struct TextFormatter {
    static func capitalizeWords(_ text: String?) -> String {
             guard let text, !text.isEmpty else { return "N/A" }
             return text.capitalized
         }
    
    static func formatTemp(_ value: Double?) -> String {
               guard let value else { return "N/A" }
               return String(format: "%.2f°C", value)
           }
}

