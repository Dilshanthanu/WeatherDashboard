import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(spacing: 0) {

                Map(position: $cameraPosition) {
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
                .onChange(of: vm.pois) { _, newPois in
                    guard let first = newPois.first else { return }

                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: first.latitude,
                                longitude: first.longitude
                            ),
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.05,
                                longitudeDelta: 0.05
                            )
                        )
                    )
                }

                Text("Top 5 Tourist Attractions in \(vm.activePlaceName)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.purple)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(vm.pois) { poi in
                            HStack(spacing: 12) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)

                                Text(poi.name)
                                    .font(.body)
                                    .onLongPressGesture {
                                        Task {
                                                 try await vm.search(for: poi.name)
                                              }
                                       }


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
