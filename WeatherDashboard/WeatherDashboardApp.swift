//
//  WeatherDashboardApp.swift
//  WeatherDashboard
//
//  Created by Dilshan Thanushka on 2025-12-12.
//

import SwiftUI
import SwiftData

@main
struct WeatherDashboardApp: App {

    @StateObject private var vm: MainAppViewModel
    private let container: ModelContainer

    init() {
        let schema = Schema([Place.self, AnnotationModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])

        let context = ModelContext(container)
        _vm = StateObject(wrappedValue: MainAppViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                
                AppBackgroundGradient()
                NavBarView()
                    .environmentObject(vm)
            }
           
            .modelContainer(container)
        }
    }
}
