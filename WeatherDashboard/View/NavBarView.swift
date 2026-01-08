//
//  NavBarView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 19/10/2025.
//

import SwiftUI
import SwiftData

struct NavBarView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 8) {

            // MARK: - Search Bar
            HStack {
                TextField("Enter location", text: $vm.query)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit { vm.submitQuery() }

                Button {
                    vm.submitQuery()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }

                Button {
                    Task {
                        await vm.refreshWeather()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                }
                .disabled(vm.isLoading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
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
                radius: 3,
                y: 2
            )
            .padding(.horizontal)

            // MARK: - Tabs
            TabView(selection: $vm.selectedTab) {

                CurrentWeatherView()
                    .tabItem {
                        Label("Now", systemImage: "sun.max.fill")
                    }
                    .tag(0)

                ForecastView()
                    .tabItem {
                        Label("Forecast", systemImage: "calendar")
                    }
                    .tag(1)

                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(2)

                VisitedPlacesView()
                    .tabItem {
                        Label("Saved", systemImage: "globe")
                    }
                    .tag(3)
            }
            .accentColor(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

        // MARK: - Loading Overlay
        .overlay {
            if vm.isLoading {
                ProgressView("Loading…")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                Color.white.opacity(
                                    colorScheme == .dark ? 0.12 : 0.9
                                )
                            )
                    )
                    .shadow(
                        color: .black.opacity(
                            colorScheme == .dark ? 0.45 : 0.15
                        ),
                        radius: 6
                    )
            }
        }

        // MARK: - Alerts
        .alert(item: $vm.appError) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(item: $vm.successAlert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }

        // MARK: - Floating Location Button
        .overlay(alignment: .bottomTrailing) {
            Button {
                Task {
                    await vm.loadDefaultLocation()
                }
            } label: {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(.blue)
                            .shadow(radius: 4)
                    )
            }
            .padding(.trailing, 20)
            .padding(.bottom, 90) // lifts above tab bar
        }
    }
}

#Preview("Light Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    NavBarView()
        .environmentObject(vm)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    NavBarView()
        .environmentObject(vm)
        .preferredColorScheme(.dark)
}
