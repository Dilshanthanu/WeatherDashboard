//
//  MapView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel

    var body: some View {
        VStack(spacing: 16) {

            Button("Test Weather API") {
                Task {
                    await vm.debugWeatherAPI()
                }
            }
            .buttonStyle(.borderedProminent)

            if vm.isLoading {
                ProgressView("Loading weather...")
            }

            ScrollView {
                Text(vm.debugText)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    MapView()
        .environmentObject(vm)
}
