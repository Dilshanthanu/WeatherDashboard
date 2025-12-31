//
//  VisitedPLacesView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

struct VisitedPlacesView: View {
    @EnvironmentObject var vm: MainAppViewModel

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(alignment: .leading, spacing: 16) {

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
                                    .foregroundColor(.secondary)
                                }
                                .onTapGesture {
                                    Task{
                                        try await  vm.loadLocation(byName: place.name)
                                    }
                                
                                       }
                                .padding(.vertical, 6)
                                .listRowBackground(Color.clear)
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
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}


#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    VisitedPlacesView()
        .environmentObject(vm)
}
