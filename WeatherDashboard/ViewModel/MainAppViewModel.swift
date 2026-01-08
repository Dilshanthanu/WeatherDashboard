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
    @Published var successAlert: SuccessAlert?

    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    @Published var visited: [Place] = []
    @Published var isLoading = false
    @Published var appError: WeatherMapError?
    @Published var activePlaceName: String = ""
    @Published var selectedTab: Int = 0

    private let defaultPlaceName = "London"

    private let weatherService = WeatherService()
    private let locationManager = LocationManager()
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context

        if let results = try? context.fetch(
            FetchDescriptor<Place>(
                sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)]
            )
        ) {
            self.visited = results
        }

        if visited.isEmpty {
            Task { await loadDefaultLocation() }
        } else if let mostRecent = visited.first {
            Task { await loadLocation(fromPlace: mostRecent) }
        }
    }

    // MARK: - Search

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

    func search(for text: String) async throws {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.google.com/search?q=\(query)") {
            await UIApplication.shared.open(url)
        }
    }

    // MARK: - Default Location

    func loadDefaultLocation() async {
        isLoading = true

        do {
            let london = try await locationManager.geocodeAddress(defaultPlaceName)
            activePlaceName = london.name

            let response = try await weatherService.fetchWeather(
                lat: london.lat,
                lon: london.lon
            )

            currentWeather = response.current
            forecast = response.daily
            pois = try await locationManager.findPOIs(
                lat: london.lat,
                lon: london.lon
            )

            focus(
                on: CLLocationCoordinate2D(
                    latitude: london.lat,
                    longitude: london.lon
                ),
                zoom: 0.2
            )

            isLoading = false
        } catch {
            isLoading = false
            appError = .missingData(
                message: "Unable to load default location."
            )
        }
    }


    func loadLocation(byName name: String) async throws {
        isLoading = true

        if let existing = visited.first(
            where: { $0.name.lowercased() == name.lowercased() }
        ) {
            await loadLocation(fromPlace: existing)

            successAlert = SuccessAlert(
                title: "Place Loaded",
                message: "\(existing.name) loaded successfully."
            )

            isLoading = false
            return
        }

        do {
            let location = try await locationManager.geocodeAddress(name)
            let response = try await weatherService.fetchWeather(
                lat: location.lat,
                lon: location.lon
            )

            currentWeather = response.current
            forecast = response.daily

            let newPlace = Place(
                name: location.name,
                latitude: location.lat,
                longitude: location.lon
            )

            context.insert(newPlace)
            try context.save()

            visited.insert(newPlace, at: 0)

            try await loadAll(for: newPlace)

            successAlert = SuccessAlert(
                title: "Alert",
                message: "Fetched and saved: \(newPlace.name)"
            )

            isLoading = false

        } catch {
            isLoading = false
            await revertToDefaultWithAlert(
                message: "Unable to load location. Reverting to London."
            )
        }
    }

    func loadLocation(fromPlace place: Place) async {
        do {
            try await loadAll(for: place)
        } catch {
            await revertToDefaultWithAlert(
                message: "Failed to load saved location."
            )
        }
    }

    private func loadAll(for place: Place) async throws {
        isLoading = true
        activePlaceName = place.name

        let response = try await weatherService.fetchWeather(
            lat: place.latitude,
            lon: place.longitude
        )

        currentWeather = response.current
        forecast = response.daily

        if place.poi.isEmpty {
            let fetched = try await locationManager.findPOIs(
                lat: place.latitude,
                lon: place.longitude
            )

            for item in fetched {
                let poi = AnnotationModel(
                    name: item.name,
                    latitude: item.latitude,
                    longitude: item.longitude,
                    place: place
                )
                place.poi.append(poi)
            }

            try context.save()
            self.pois = fetched
        } else {
            self.pois = place.poi.map {
                AnnotationModel(
                    name: $0.name,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
        }

        focus(
            on: CLLocationCoordinate2D(
                latitude: place.latitude,
                longitude: place.longitude
            )
        )

        place.lastUsedAt = Date()
        try context.save()

        visited.removeAll { $0.id == place.id }
        visited.insert(place, at: 0)

        isLoading = false
    }

    private func revertToDefaultWithAlert(message: String) async {
        appError = .missingData(message: message)
        await loadDefaultLocation()
    }

    func focus(
        on coordinate: CLLocationCoordinate2D,
        zoom: Double = 0.1
    ) {
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

    // MARK: - Delete

    func delete(place: Place) {
        context.delete(place)

        do {
            try context.save()
            visited.removeAll { $0.id == place.id }

            if activePlaceName == place.name {
                Task {
                    if let next = visited.first {
                        await loadLocation(fromPlace: next)
                    } else {
                        await loadDefaultLocation()
                    }
                }
            }
        } catch {
            appError = .deleteFailed("Failed to delete saved place.")
        }
    }
    func refreshWeather() async {
        if let place = visited.first {
            await loadLocation(fromPlace: place)
        } else {
            await loadDefaultLocation()
        }
    }

}
