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
    @StateObject private var metric = Metric()
    
    private var cs: ClassificationService {
        let newCS = ClassificationService()
        newCS.setup()
        return newCS
    }
    
    var body: some View {
        return VStack {
            if let img = inputImage {
                VStack {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                    Text("Gender: \(metric.gender)")
                    Text("Age: \(metric.age)")
                    Text("Emotion: \(metric.emotion)")
                }
            }
            Button(action: revealPicker) {
                Text("Add Photo")
                    .padding()
            }
            .background(RoundedRectangle(cornerRadius: 15)
                            .opacity(0.2))
            Spacer()
        }
        .onChange(of: inputImage) { _ in
            infer(inputImage: inputImage)
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func revealPicker() {
        showPicker = true
    }
    
    func infer(inputImage: UIImage?) {
        guard let inputImage = inputImage else {
            print("No input image")
            return
        }
        let ciImage = CIImage(cgImage: inputImage.cgImage!)
        let result: [String?] = cs.classify(image: ciImage)
        metric.update(fromResult: result)
    }
    
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
