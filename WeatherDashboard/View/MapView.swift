//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData
import MapKit

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(spacing: 0) {
                ZStack(alignment: .top) {

                    Map {
                        UserAnnotation()
                        ForEach(vm.pois) { poi in
                            Marker(
                                poi.name,
                                coordinate: CLLocationCoordinate2D(
                                    latitude: poi.latitude,
                                    longitude: poi.longitude
                                )
                            )
                        }
                    }
                    .frame(height: 360)

                    // Search bar overlay
                }

                // MARK: - TITLE STRIP
                Text("Top 5 Tourist Attractions in \(vm.activePlaceName)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.purple)

                // MARK: - POI LIST
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(vm.pois) { poi in
                            HStack(spacing: 12) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)

                                Text(poi.name)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    MapView()
        .environmentObject(vm)
}
