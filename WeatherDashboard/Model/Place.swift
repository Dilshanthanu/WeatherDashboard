//
//  Place.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//
// MARK:  Basic data models - edit them to create a relationship

import SwiftData
import CoreLocation

@Model
final class Place {
    @Attribute(.unique) var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var lastUsedAt: Date
    var poi: [AnnotationModel]

    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        poi: [AnnotationModel] = []
        
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.lastUsedAt = .now
        self.poi = poi
        
    }
}

@Model
final class AnnotationModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    var place: Place?


    init(name: String, latitude: Double, longitude: Double , place: Place? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.place = place

    }

}
