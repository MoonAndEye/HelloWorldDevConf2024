//
//  ImageClassify.swift
//  ITHelloWorld_2024
//
//  Created by Marvin on 2024/9/7.
//

import SwiftUI
import PhotosUI

struct ImageClassify: View {
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var image: Image? = nil
    @State private var predictResult: String = ""
    
    /// A predictor instance that uses Vision and Core ML to generate prediction strings from a photo.
    let imagePredictor = ImagePredictor()

    /// The largest number of predictions the main view controller displays the user.
    let predictionsToShow = 2
    
    var displayPredictedResult: String {
        if predictResult.isEmpty {
            return "辨識結果: -"
        }
        return predictResult
    }
    
    var body: some View {
        VStack {
            Text(displayPredictedResult)
                .padding(.top)
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
            } else {
                Rectangle()
                    .foregroundStyle(.pink)
                    .cornerRadius(10)
                    .padding()
            }
            Text("圖片辨識 - image classification")
                .padding()
            // Define the app's Photos picker.
            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("選取相簿中的圖片")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 40)
            .onChange(of: selectedPhotoItem) { newItem in
                // Load the image from the photo library
                guard let newItem = newItem else { return }
                newItem.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data, let uiImage = UIImage(data: data) {
                            image = Image(uiImage: uiImage)
                            if let image {
                                classifyImage(image)
                            }
                        } else {
                            print("Failed to load image.")
                        }
                    case .failure(let error):
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension ImageClassify {
    // MARK: Image prediction methods
    
    func updatePredictionLabel(_ message: String) {
        predictResult = message
//        DispatchQueue.main.async {
//            self.predictionLabel.text = message
//        }
//
//        if firstRun {
//            DispatchQueue.main.async {
//                self.firstRun = false
//                self.predictionLabel.superview?.isHidden = false
//                self.startupPrompts.isHidden = true
//            }
//        }
    }
    
    private func classifyImage(_ image: Image) {
        do {
            try imagePredictor.makePredictions(for: image, completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

    /// The method the Image Predictor calls when its image classifier model generates a prediction.
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
        updatePredictionLabel(predictionString)
    }

    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}


#Preview {
    ImageClassify()
}
