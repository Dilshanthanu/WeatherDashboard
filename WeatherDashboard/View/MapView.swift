import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(spacing: 0) {

                // MARK: - Map
                Map(
                    coordinateRegion: $vm.mapRegion,
                    annotationItems: vm.pois
                ) { poi in
                    MapAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: poi.latitude,
                            longitude: poi.longitude
                        )
                    ) {
                        VStack(spacing: 2) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)

                            Text(poi.name)
                                .font(.caption)
                                .fixedSize()
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .frame(height: 360)

                // MARK: - Section Header
                Text("Top 5 Tourist Attractions in \(vm.activePlaceName)")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        Color.white.opacity(
                            colorScheme == .dark ? 0.08 : 0.15
                        )
                    )

                // MARK: - POI List
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(vm.pois) { poi in
                            POIRow(name: poi.name)
                                .onLongPressGesture {
                                    Task {
                                        try await vm.search(for: poi.name)
                                    }
                                }

                            Divider()
                                .opacity(colorScheme == .dark ? 0.4 : 0.8)
                        }
                    }
                    .padding()
                }
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
                .padding()
            }
        }
    }
}


