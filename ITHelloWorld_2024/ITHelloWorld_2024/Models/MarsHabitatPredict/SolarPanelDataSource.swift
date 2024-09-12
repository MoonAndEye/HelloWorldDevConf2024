//
//  Untitled.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/12.
//

import Foundation

struct SolarPanelDataSource {
    /// Possible values for solar panels in the habitat
    let values = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
    
    func title(for index: Int) -> String? {
        guard index < values.count else { return nil }
        return String(values[index])
    }
    
    func value(for index: Int) -> Double? {
        guard index < values.count else { return nil }
        return Double(values[index])
    }
}
