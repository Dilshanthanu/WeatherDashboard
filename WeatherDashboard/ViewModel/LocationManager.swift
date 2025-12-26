//
//  LocationManager.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import Foundation
import CoreLocation
@preconcurrency import MapKit


@MainActor
final class LocationManager {

    func geocodeAddress(_ address: String) async throws -> (name: String, lat: Double, lon: Double) {
        let geocoder = CLGeocoder()

        let placemarks = try await geocoder.geocodeAddressString(address)

        guard
            let placemark = placemarks.first,
            let location = placemark.location
        else {
            throw WeatherMapError.geocodingFailed(address)
        }

        let name =
            placemark.name ??
            placemark.locality ??
            address

        return (
            name: name,
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
    }

    func findPOIs(
        lat: Double,
        lon: Double,
        limit: Int = 5
    ) async throws -> [AnnotationModel] {

        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "tourist attractions"
        request.region = region
        request.resultTypes = .pointOfInterest

        let search = MKLocalSearch(request: request)

        do {
            let response = try await search.start()

            return response.mapItems
                .compactMap { item -> AnnotationModel? in
                    guard let name = item.name else { return nil }

                    return AnnotationModel(
                        name: name,
                        latitude: item.placemark.coordinate.latitude,
                        longitude: item.placemark.coordinate.longitude
                    )
                }
                .prefix(limit)
                .map { $0 }


        } catch {
            throw WeatherMapError.missingData(
                message: "Unable to load nearby tourist attractions."
            )
        }
    }

}
