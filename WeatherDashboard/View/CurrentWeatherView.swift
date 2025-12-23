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
                          
                          Text("Sunday, Oct 12")
                              .font(Font.system(size: 14, weight: .light))
                      }
                VStack{
                    HStack {
                                       Text("9°C")
                                           .font(.system(size: 60, weight: .bold))

                                       Spacer()

                                       Image(systemName: "cloud.fill")
                                           .font(.system(size: 60))
                                   }
                    Text("Over cast clouds")
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
                            Text("1023hPa")
                                .font(.callout)
                        }
                        .padding(5)
                        HStack(spacing: 10){
                            Image(systemName: "sunrise")
                                .foregroundColor(Color.blue)
                            Text("Sunrice")
                                .font(.callout)
                            Spacer()
                            Text("06:23")
                                .font(.callout)
                        }
                        .padding(5)
                        HStack(spacing: 10){
                            Image(systemName: "sunset")
                                .foregroundColor(Color.blue)
                            Text("Sunset")
                                .font(.callout)
                            Spacer()
                            Text("08:14")
                                .font(.callout)
                        }
                        .padding(5)
                        
                        
                        
                            
                    }
                    .padding(.top, 24)
                    
                    HStack(spacing: 10 ){
                        Image(systemName: "cloud.rain")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("A bit chilly today - wear a jacket or coat")
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
