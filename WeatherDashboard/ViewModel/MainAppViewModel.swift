//
//  MainAppViewModel.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData
import MapKit
import Combine

@MainActor
final class MainAppViewModel: ObservableObject {
    @Published var query = ""
    @Published var currentWeather: Current?
    @Published var forecast: [Daily] = []
    @Published var pois: [AnnotationModel] = []
    @Published var mapRegion = MKCoordinateRegion()
    @Published var visited: [Place] = []
    @Published var isLoading = false
    @Published var appError: WeatherMapError?
    @Published var activePlaceName: String = ""
    private let defaultPlaceName = "London"
    @Published var selectedTab: Int = 0


    /// Create and use a WeatherService model (class) to manage fetching and decoding weather data
    private let weatherService = WeatherService()

    /// Create and use a LocationManager model (class) to manage address conversion and tourist places
    private let locationManager = LocationManager()
    
    /// Use a context to manage database operations
    private let context: ModelContext

    init(context: ModelContext) {
        // Initialize the ModelContext and attempt to fetch previously visited places from SwiftData, sorted by most recent use.
        // If no visited places exist (first launch), load the default location.
        // Otherwise, load the most recently used place.
        self.context = context

        // Corrected FetchDescriptor to include sorting by 'lastUsedAt' in reverse order.
        if let results = try? context.fetch(
            FetchDescriptor<Place>(sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)])
        ) {
            self.visited = results
        }

        // First launch: no data → perform full London setup
        if visited.isEmpty {
            Task {
                await loadDefaultLocation()
            }
        } else if let mostRecent = visited.first {
            // Otherwise, load most recently used place
            Task {
                await loadLocation(fromPlace: mostRecent)
            }
        }
    }

    func submitQuery() {
        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else {
            appError = .missingData(message: "Please enter a valid location.")
            
            return
        }
        Task {
            do {
                try await loadLocation(byName: city)
                query = ""
            } catch {
                appError = .networkError(error)
            }
        }
    }
    func loadDefaultLocation() async {
        
        isLoading = true;
        do {
            let london = try await locationManager.geocodeAddress(defaultPlaceName)
            activePlaceName = london.name
            pois = try await locationManager.findPOIs(lat: london.lat, lon: london.lon)
            let response = try await weatherService.fetchWeather(
                lat: london.lat,
                lon: london.lon
            )
            currentWeather = response.current
            forecast = response.daily
            isLoading = false
        }catch {
            isLoading = false
        await revertToDefaultWithAlert(
                        message: "Unable to load defult location. Please try again."
        )
        }
    }

    func search(for text: String) async throws {
        // If the query is not empty, calls `select(placeNamed:)` with the current query string.
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
           if let url = URL(string: "https://www.google.com/search?q=\(query)") {
               await UIApplication.shared.open(url)
           }
    }

    /// Validate weather before saving a new place; create POI children once.
    func loadLocation(byName: String) async throws {
        isLoading = true;
        if let existingPlace = visited.first(where: {
            $0.name.lowercased() == byName.lowercased()
        }) {
            await loadLocation(fromPlace: existingPlace)
                   isLoading = false
                   return
        }else{
            
            do {
                let location = try await locationManager.geocodeAddress(byName)
                let response = try await weatherService.fetchWeather(
                    lat: location.lat,
                    lon: location.lon
                )
               
                let visitPois = try await locationManager.findPOIs(lat: location.lat, lon: location.lon)
                
                let visitPlace = Place(
                    name: location.name,
                    latitude: location.lat,
                    longitude: location.lon,
                )
                
                context.insert(visitPlace)
                try context.save()
                visited.insert(visitPlace, at: 0)

                try await loadAll(for: visitPlace)

                isLoading = false
            }catch {
                isLoading = false
            await revertToDefaultWithAlert(
                            message: "Unable to load location. Reverting to London."
            )
            }
        }

    }

    func loadLocation(fromPlace place: Place) async {
        do {
            try await loadAll(for: place)
        } catch {
            await revertToDefaultWithAlert(
                message: "Failed to load saved location. Reverting to London."
            )
        }
    }

    private func revertToDefaultWithAlert(message: String) async {

        appError = .missingData(message: message)
        await loadDefaultLocation()
    }



    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.02) {
        withAnimation {
            mapRegion = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: zoom,
                    longitudeDelta: zoom
                )
            )
        }
    }

    private func loadAll(for place: Place) async throws {

        isLoading = true
        activePlaceName = place.name

        do {
            let response = try await weatherService.fetchWeather(
                lat: place.latitude,
                lon: place.longitude
            )
            currentWeather = response.current
            forecast = response.daily
            if place.poi.isEmpty {
               
                let fetchedAnnotations = try await locationManager.findPOIs(
                    lat: place.latitude,
                    lon: place.longitude
                )

                for annotation in fetchedAnnotations {
                    let poi = AnnotationModel(
                        name: annotation.name,
                        latitude: annotation.latitude,
                        longitude: annotation.longitude,
                        place: place
                    )
                    place.poi.append(poi)
                }
                focus(
                    on: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                )

                try context.save()

                self.pois = fetchedAnnotations

            } else {
               
                self.pois = place.poi.map { poi in
                    AnnotationModel(
                        name: poi.name,
                        latitude: poi.latitude,
                        longitude: poi.longitude
                    )
                }
            }
            place.lastUsedAt = Date()
            try context.save()
            visited.removeAll { $0.id == place.id }
            visited.insert(place, at: 0)

            isLoading = false

        } catch {
            isLoading = false
            await revertToDefaultWithAlert(
                message: "Failed to load location data. Reverting to London."
            )
        }
    }

    func delete(place: Place) {

        context.delete(place)

        do {
            try context.save()

            visited.removeAll { $0.id == place.id }

            if activePlaceName == place.name {
                if let nextPlace = visited.first {
                    Task {
                        await loadLocation(fromPlace: nextPlace)
                    }
                } else {
                    Task {
                        await loadDefaultLocation()
                    }
                }
            }

        } catch {
            appError = .deleteFailed(
                "Failed to delete saved place."
            )
        }
    }


}
