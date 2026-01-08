//
//  VisitedPlacesView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

struct VisitedPlacesView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Header
                HStack(spacing: 10) {
                    Text("Visited Places")
                        .font(.system(size: 28, weight: .semibold))

                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 24))
                        .foregroundColor(.red)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // MARK: - Content
                ZStack {
                    if vm.visited.isEmpty {
                        NoDataView(
                            title: "No Places Found",
                            message: "You haven’t visited any places yet.",
                            systemImage: "tray"
                        )
                    } else {
                        List {
                            ForEach(vm.visited) { place in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(place.name)
                                        .font(.headline)
                                        .onLongPressGesture {
                                            Task {
                                                try await vm.search(for: place.name)
                                            }
                                        }

                                    Text(
                                        String(
                                            format: "Lat: %.4f, Lon: %.4f",
                                            place.latitude,
                                            place.longitude
                                        )
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                                
                                .padding(.vertical, 6)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    Task {
                                        try await vm.loadLocation(byName: place.name)
                                    }
                                }
                                .listRowBackground(
                                    Color.white.opacity(
                                        colorScheme == .dark ? 0.04 : 0.12
                                    )
                                )
                                .cornerRadius(8)
                            }
                            .onDelete { indexes in
                                for index in indexes {
                                    let place = vm.visited[index]
                                    vm.delete(place: place)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
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
                            radius: 10,
                            y: 6
                        )
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview("Light Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    VisitedPlacesView()
        .environmentObject(vm)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    VisitedPlacesView()
        .environmentObject(vm)
        .preferredColorScheme(.dark)
}
