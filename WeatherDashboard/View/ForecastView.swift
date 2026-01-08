//
//  ForecastView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import Charts
import SwiftData

// MARK: - Temperature Category
enum TempCategory: String, CaseIterable {
    case cold = "Cold"
    case mild = "Mild"
    case warm = "Warm"
    case hot = "Hot"
    case unknown = "Unknown"

    var color: Color {
        switch self {
        case .cold: return .blue
        case .mild: return .green
        case .warm: return .orange
        case .hot:  return .red
        case .unknown: return .gray
        }
    }

    static func from(tempC: Double) -> TempCategory {
        if tempC < 10 { return .cold }
        else if tempC < 20 { return .mild }
        else if tempC < 28 { return .warm }
        else { return .hot }
    }
}

enum TempType: String {
    case min = "Min"
    case max = "Max"
}

// MARK: - Chart Data Model
private struct TempData: Identifiable {
    let id = UUID()
    let time: Date
    let type: TempType
    let value: Double
    let category: TempCategory
}

// MARK: - Forecast View
struct ForecastView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.colorScheme) private var colorScheme

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
                )
            ]
        }
    }

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(alignment: .leading, spacing: 12) {

                // MARK: - Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("8 Day Forecast – \(vm.activePlaceName)")
                        .font(.system(size: 28, weight: .semibold))

                    Text("Daily Highs & Lows (°C)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                // MARK: - Chart
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
                .frame(height: 220)

                // MARK: - Summary Header
                Text("Detailed Daily Summary")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 8)

                // MARK: - Daily List
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

                            HStack(spacing: 12) {
                                Text("Low \(Int(day.temp.min))°C")
                                Text("High \(Int(day.temp.max))°C")
                            }
                            .font(.system(size: 12))

                            Divider()
                        }
                        .padding(.horizontal)
                        .padding(.top, index == 0 ? 12 : 0)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            Color.white.opacity(
                                colorScheme == .dark ? 0.06 : 0.12
                            )
                        )
                )
                .shadow(
                    color: .black.opacity(
                        colorScheme == .dark ? 0.45 : 0.15
                    ),
                    radius: 8,
                    y: 6
                )
                .padding(.top, 6)

                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Forecast")
    }
}

#Preview("Light Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    ForecastView()
        .environmentObject(vm)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    ForecastView()
        .environmentObject(vm)
        .preferredColorScheme(.dark)
}
