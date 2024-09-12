//
//  MarsHabitatPredictPriceView.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/12.
//

import SwiftUI

struct MarsHabitatPredictPriceView: View {
    
    let marsHabitatPricer = try? MarsHabitatPricer(configuration: .init())
    
    let selectedGreenHouseDataSource: GreenhousesDataSource = .init()
    @State var selectedGreenHouse: Int = 0
    
    let solarPanelDataSource: SolarPanelDataSource = .init()
    @State var selectedSolarPanel: Double = 0
    
    let sizeDataSource: SizeDataSource = .init()
    @State var selectedSize: Int = 0
    
    /// Formatter for the output.
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var predictdPrice: Double {
        
        guard let marsHabitatPricer = marsHabitatPricer else {
            fatalError("The Mars Habitat Pricer failed to load.")
        }

        do {
            // Use the model to make a price prediction.
            let output = try marsHabitatPricer.prediction(solarPanels: selectedSolarPanel,
                                                          greenhouses: Double(selectedGreenHouse),
                                                          size: Double(selectedSize))

            // Format the price for display in the UI.
            let price = output.price
            print("預測價: \(price)")
            return price
        } catch { fatalError("Unexpected runtime error: \(error).") }
    }
    
    var valueString: String {
        priceFormatter.string(for: predictdPrice) ?? "-"
    }

    var body: some View {
        
        VStack {
            
            Text("火星房地產預測\nPredicted price (millions)")
                .font(.system(size: 24))
            Text(valueString)
            HStack {
                Picker("Select solar panels", selection: $selectedSolarPanel) {
                    ForEach(solarPanelDataSource.values, id: \.self) {
                        Text(String(format: "%.1f", $0))
                    }
                }
                .pickerStyle(.wheel) // 選擇適合的樣式，例如：wheel, segment, menu
                
                Picker("Select green houses", selection: $selectedGreenHouse) {
                    ForEach(selectedGreenHouseDataSource.values, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel) // 選擇適合的樣式，例如：wheel, segment, menu
                
                
                Picker("Select your Acres", selection: $selectedSize) {
                    ForEach(sizeDataSource.values, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel) // 選擇適合的樣式，例如：wheel, segment, menu
            }
            .padding()
        }
        
    }
}

#Preview {
    MarsHabitatPredictPriceView()
}
