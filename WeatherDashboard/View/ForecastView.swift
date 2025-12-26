//
//  ForecastView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import Charts
import SwiftData


import SwiftUI
import Charts   // Include if you plan to show a chart later

// MARK: - Temperature Category
/// Example of how to categorize temperatures for display.
/// Add more cases or adjust logic as needed.
enum TempCategory: String, CaseIterable {
    case cold = "Cold"
    case mild = "Mild"
    case warm = "Warm"
    case hot = "Hot"
    case unknown = "Unknown"

    /// Choose a color to represent this category.
    var color: Color {
        switch self {
        case .cold:
            return .blue
        case .mild:
            return .green
        case .warm:
            return .orange
        case .hot:
            return .red
        case .unknown:
            return .gray
        }
    }

    /// Convert a Celsius temperature into a category.
    static func from(tempC: Double) -> TempCategory {
        if tempC <= 0 {
            return .cold
        }else if tempC < 10 {
            return .cold }
        else if tempC < 20 {
            return .mild }
        else if tempC < 28 {
            return .warm }
        else {
            return .hot
        }
    
    }
}
enum TempType: String {
    case min = "Min"
    case max = "Max"
}


// MARK: - Temperature Data Model
/// A single temperature reading for the chart or list.
private struct TempData: Identifiable {
    let id = UUID()
    let time: Date          // e.g., forecast date
    let type: TempType        // e.g., "High" or "Low"
    let value: Double       // numeric value
    let category: TempCategory
}

// MARK: - Forecast View
/// Stubbed Forecast View that includes an image placeholder to show
/// what the final view will look like. Replace the image once real data and charts are added.
struct ForecastView: View {
    @EnvironmentObject var vm: MainAppViewModel
    
    /// Converts forecast data into chart-friendly entries.
    private var chartData: [TempData] {
        vm.forecast.flatMap { day in
            [
                
                TempData(
                    time: Date(timeIntervalSince1970: TimeInterval(day.dt)),
                    type: .min,
                    value: day.temp.min,
                    category: .from(tempC: day.temp.min)
                ),
                TempData(
                    time: Date(timeIntervalSince1970: TimeInterval(day.dt)),
                    type: .max,
                    value: day.temp.max,
                    category: .from(tempC: day.temp.max)
                ),
                
                
                // TODO: add a "Low" entry or other data points if needed
            ]
        }
    }
    
    var body: some View {
        ZStack{
            AppBackgroundGradient()
            VStack(alignment: .leading, spacing: 12) {
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("8 Day Forecast - \(vm.activePlaceName)")
                        .font(.system(size: 28, weight: .semibold))
                        .padding(.bottom, 4)
                    
                    Text("Daily Highs & Lows (°C)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                }
                
                Chart(chartData) { item in
                    BarMark(
                        x: .value("Day", item.time, unit: .day),
                        y: .value("Temperature", item.value)
                    )
                    .foregroundStyle(item.category.color)
                    .position(by: .value("Type", item.type.rawValue))
                    .cornerRadius(4)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.weekday(.abbreviated))
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Detailed Daily Summary")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(Array(vm.forecast.enumerated()), id: \.element.dt) { index, day in
                        VStack(alignment: .leading, spacing: 8) {
                            
                            let category = WeatherAdviceCategory.from(
                                temp: day.temp.max,
                                description: day.weather.first?.description ?? ""
                            )
                            
                            Text(
                                DateFormatterUtils.formattedDate(
                                    from: day.dt ?? 0,
                                    format: "EEEE, MMM dd"
                                )
                            )
                            .font(.system(size: 16, weight: .bold))
                            
                           
                            Text(category.adviceText)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            HStack {
                                Text("Low \(Int(day.temp.min))°C")
                                    .font(.system(size: 10, weight: .regular))
                                
                                Text("High \(Int(day.temp.max))°C")
                                    .font(.system(size: 10, weight: .regular))
                            }

                            
                            
                            Divider()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, index == 0 ? 12 : 0)
                    }
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .indigo.opacity(0.1),
                            .blue.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
                .navigationTitle("Forecast")
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    ForecastView()
        .environmentObject(vm)
}

