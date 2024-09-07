//
//  WritingToolDemoSwiftUI.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/2.
//

import SwiftUI

struct WritingToolDemoSwiftUI: View {
    
    @State var text: String = ""
    
    var body: some View {
        
        TextField("Please enter your text", text: $text)
            .padding()
            .border(.red)
    }
}

#Preview {
    WritingToolDemoSwiftUI()
}
