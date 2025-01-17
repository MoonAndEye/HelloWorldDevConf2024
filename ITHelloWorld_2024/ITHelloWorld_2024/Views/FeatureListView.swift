//
//  FeatureListView.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/1.
//

import SwiftUI

struct FeatureListView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NavigationLink {
                        TranslationContentView()
                    } label: {
                        Text("Transition Demo")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    NavigationLink {
                        ImageClassify()
                    } label: {
                        Text("Image Classify")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    NavigationLink {
                        MarsHabitatPredictPriceView()
                    } label: {
                        Text("Mars Habitat Predict")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("功能列表").font(.headline).frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    FeatureListView()
}
