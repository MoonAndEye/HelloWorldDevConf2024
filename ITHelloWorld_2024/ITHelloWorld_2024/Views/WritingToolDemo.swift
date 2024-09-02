//
//  WritingToolDemo.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/1.
//

#if canImport(UIKit)
import UIKit
import SwiftUI

// 創建一個遵循 UIViewControllerRepresentable 的結構
struct WritingToolsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WritingToolsViewController {
        // 創建 ViewController 的實例
        WritingToolsViewController()
    }
    
    func updateUIViewController(_ uiViewController: WritingToolsViewController, context: Context) {
        // 這裡可以實現更新 ViewController 狀態的邏輯
    }
}

struct WritingToolDemo: View {
    
    @State var inputedString = ""
    
    var body: some View {
        WritingToolsViewControllerRepresentable()
    }
}

#Preview {
    WritingToolDemo()
}
#endif
