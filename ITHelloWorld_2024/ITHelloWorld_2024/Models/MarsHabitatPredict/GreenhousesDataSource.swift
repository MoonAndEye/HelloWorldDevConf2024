//
//  Untitled.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/12.
//

import Foundation

struct GreenhousesDataSource {
    /// Possible values for greenhouses in the habitat
    let values = [1, 2, 3, 4, 5]
    
    func title(for index: Int) -> String? {
        guard index < values.count else { return nil }
        return String(values[index])
    }
    
    func value(for index: Int) -> Double? {
        guard index < values.count else { return nil }
        return Double(values[index])
    }
}
