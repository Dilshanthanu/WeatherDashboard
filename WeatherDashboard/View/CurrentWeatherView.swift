//
//  CurrentWeatherView.swift
//  WeatherDashboardTemplate
//
//  Created by girish lukka on 18/10/2025.
//

import SwiftUI
import SwiftData


struct CurrentWeatherView: View {
    @EnvironmentObject var vm: MainAppViewModel

    var body: some View {
        ZStack{
            AppBackgroundGradient()
            VStack{
                      HStack{
                          Text("Londan")
                              .font(Font.largeTitle.bold())
                          Spacer()
                          
                          Text(DateFormatterUtils.formattedDate(
                            from: vm.currentWeather?.dt ?? 0,
                            format: "EEEE, MMM dd"
                        ))
                              .font(Font.system(size: 14, weight: .light))
                      }
                VStack{
                    HStack {
                        Text("\(vm.currentWeather?.temp ?? 0, specifier:"%.0f")°C")
                                           .font(.system(size: 60, weight: .bold))

                                       Spacer()

                        if let weather = vm.currentWeather?.weather.first{
                            Image(systemName: weather.SymbolName)
                                .font(.system(size: 60))
                                .foregroundColor(.primary)
                        }

                                   }
                    Text(vm.currentWeather?.weather.first?.description ?? "")
                        .font(Font.title3.bold())
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.up")
                            .font(.title3)
                            .foregroundColor(.primary)
                        Text("12°")
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "arrow.down")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .font(.caption)
                        Text("6°")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack{
                        Text("Details")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                        
                        HStack(spacing: 10){
                            Image(systemName: "gauge")
                                .foregroundColor(Color.blue)
                            Text("Pressure")
                                .font(.callout)
                            Spacer()
                            Text("\(vm.currentWeather?.pressure ?? 0) hPa")
                                .font(.callout)

                        }
                        .padding(5)
                        HStack(spacing: 10){
                            Image(systemName: "sunrise")
                                .foregroundColor(Color.blue)
                            Text("Sunrice")
                                .font(.callout)
                            Spacer()
                            Text(
                                DateFormatterUtils.formattedDate(
                                      from: vm.currentWeather?.sunrise ?? 0,
                                      format: "HH:mm"
                                  )
                            )
                            .font(.callout)
                        }
                        .padding(5)
                        HStack(spacing: 10){
                            Image(systemName: "sunset")
                                .foregroundColor(Color.blue)
                            Text("Sunset")
                                .font(.callout)
                            Spacer()
                            Text(
                                DateFormatterUtils.formattedDate(
                                       from: vm.currentWeather?.sunset ?? 0,
                                       format: "HH:mm"
                                   )
                            )
                            .font(.callout)

                        }
                        .padding(5)
                        
                        
                        
                            
                    }
                    .padding(.top, 24)
                    
                    HStack(spacing: 10 ){
                        if let temp = vm.currentWeather?.temp {
                            let category = WeatherAdviceCategory.from(
                                temp: temp,
                                description: vm.currentWeather?.weather.first?.description ?? ""
                            )

                            Image(systemName: category.icon)
                                .font(.system(size: 60))
                                .foregroundColor(category.color)
                            Text(category.adviceText)
                        }

                     
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.accentColor.opacity(0.15))
                    .cornerRadius(20)
                    .padding(.top, 20) 
                    
                    
                    
                    
                    
                }
                .padding()
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.15))
                )
                .shadow(color: Color.black.opacity(0.15),
                        radius: 10,
                        x: 0,
                        y: 8)


                Spacer()
                
                  }
                  .frame(height: 600)
                  .padding(20)

              }
        }
        
      
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    CurrentWeatherView()
        .environmentObject(vm)
}
