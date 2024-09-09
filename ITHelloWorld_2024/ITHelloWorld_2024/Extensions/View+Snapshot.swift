//
//  View+Snapshot.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/8.
//
import SwiftUI

extension View {
    /// Usually you would pass  `@Environment(\.displayScale) var displayScale`
    func render(scale displayScale: CGFloat = 1.0) -> UIImage? {
        let renderer = ImageRenderer(content: self)

        renderer.scale = displayScale
        
        return renderer.uiImage
    }
    
}
