//
//  Main.swift
//  Minitrue
//
//  Created by Yuanqi Wang on 1/15/22.
//

import SwiftUI

struct Main: View {
    @State private var inputImage: UIImage?
    @State private var showPicker = false
    @State private var metrics: [FaceMetric]?

    
    private var faceDetectionService = FaceDetectionService()
    
    var body: some View {
        VStack {
            if let img = inputImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
            }
            Button(action: revealPicker) {
                Text("Add Photo")
                    .padding()
            }
            .background(RoundedRectangle(cornerRadius: 15)
                            .opacity(0.2))
            if metrics != nil {
                List(metrics!) { metric in
                    HStack {
                        Image(uiImage: UIImage(cgImage: metric.image))
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("Gender: \(metric.gender.components(separatedBy: " ")[0])")
                                .font(.system(size: 14))
                            Text("Age: \(metric.age.components(separatedBy: " ")[0])")
                                .font(.system(size: 14))
                            Text("Emotion: \(metric.emotion.components(separatedBy: " ")[0])")
                                .font(.system(size: 14))
                        }
                        Spacer()
                    }
                }
            }
        }
        .onChange(of: inputImage) { _ in
            processInput(inputImage: inputImage)
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func revealPicker() {
        showPicker = true
    }
    
    func processInput(inputImage: UIImage?) {
        guard let inputImage = inputImage else {
            print("No input image")
            return
        }
        faceDetectionService.isolateFaces(fromCGImage: inputImage.cgImage!)
        metrics = faceDetectionService.report()
    }
    
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
