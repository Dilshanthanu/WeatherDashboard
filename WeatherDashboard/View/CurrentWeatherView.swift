//
//  CurrentWeatherView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

struct CurrentWeatherView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack {
                // MARK: - Header
                HStack {
                    Text(vm.activePlaceName)
                        .font(.largeTitle.bold())

                    Spacer()

                    Text(
                        DateFormatterUtils.formattedDate(
                            from: vm.currentWeather?.dt ?? 0,
                            format: "EEEE, MMM dd"
                        )
                    )
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(.secondary)
                }

                VStack {
                    // MARK: - Temperature & Icon
                    HStack {
                        Text("\(vm.currentWeather?.temp ?? 0, specifier: "%.0f")°C")
                            .font(.system(size: 60, weight: .bold))

                        Spacer()

                        if let weather = vm.currentWeather?.weather.first {
                            Image(systemName: weather.SymbolName)
                                .font(.system(size: 60))
                                .foregroundStyle(.primary)
                        }
                    }

                    Text(
                        TextFormatter.capitalizeWords(
                            vm.currentWeather?.weather.first?.description ?? ""
                        )
                    )
                    .font(.title3.bold())
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: - Min / Max
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.up")
                        Text(TextFormatter.formatTemp(vm.forecast.first?.temp.max))

                        Image(systemName: "arrow.down")
                        Text(TextFormatter.formatTemp(vm.forecast.first?.temp.min))
                    }
                    .font(.title3)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: - Details
                    VStack {
                        Text("Details")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        detailRow(
                            icon: "gauge",
                            title: "Pressure",
                            value: "\(vm.currentWeather?.pressure ?? 0) hPa"
                        )

                        detailRow(
                            icon: "sunrise",
                            title: "Sunrise",
                            value: DateFormatterUtils.formattedDate(
                                from: vm.currentWeather?.sunrise ?? 0,
                                format: "HH:mm"
                            )
                        )

                        detailRow(
                            icon: "sunset",
                            title: "Sunset",
                            value: DateFormatterUtils.formattedDate(
                                from: vm.currentWeather?.sunset ?? 0,
                                format: "HH:mm"
                            )
                        )
                    }
                    .padding(.top, 24)

                    // MARK: - Weather Advice Card
                    if let temp = vm.currentWeather?.temp {
                        let category = WeatherAdviceCategory.from(
                            temp: temp,
                            description: vm.currentWeather?.weather.first?.description ?? ""
                        )

                        HStack(alignment: .top, spacing: 14) {
                            Image(systemName: category.icon)
                                .font(.system(size: 48))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [category.color, category.color.opacity(0.6)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )

                            VStack(alignment: .leading, spacing: 6) {
                                Text(category.adviceText)
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    colorScheme == .dark
                                    ? .thinMaterial
                                    : .ultraThinMaterial
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    Color.white.opacity(
                                        colorScheme == .dark ? 0.12 : 0.25
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: .black.opacity(
                                colorScheme == .dark ? 0.4 : 0.15
                            ),
                            radius: 10,
                            y: 5
                        )
                        .padding(.top, 20)
                    }
                }
                .padding(20)
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
                        colorScheme == .dark ? 0.4 : 0.15
                    ),
                    radius: 10,
                    y: 8
                )

                Spacer()
            }
            .frame(height: 600)
            .padding(20)
        }
    }

    // MARK: - Detail Row Helper
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)

            Text(title)
                .font(.callout)

            Spacer()

            Text(value)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding(5)
    }
}

#Preview("Light Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    CurrentWeatherView()
        .environmentObject(vm)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    CurrentWeatherView()
        .environmentObject(vm)
        .preferredColorScheme(.dark)
}
