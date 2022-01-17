//
//  Main.swift
//  Minitrue
//
//  Created by Yuanqi Wang on 1/15/22.
//

import SwiftUI

struct Main: View {
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var metrics: [FaceMetric]?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showSheet = false

    
    private var faceDetectionService = FaceDetectionService()
    
    var body: some View {
        VStack {
            if let img = inputImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200, alignment: .center)
            }
            Button(action: revealPicker) {
                Text("Inspect")
                    .foregroundColor(.red)
                    .frame(width: 80, height: 30)
            }
            .actionSheet(isPresented: $showSheet) {
                ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                    .default(Text("Photo Library")) {
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    },
                    .default(Text("Camera")) {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    },
                    .cancel()
                ])
            }
            .background(Capsule())
            if inputImage != nil && metrics == nil {
                Text("Looking for Faces")
            }
            if metrics != nil {
                if metrics?.count == 0 {
                    Text("No Face Found!")
                } else {
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
                    .listRowInsets(EdgeInsets())
                }

            }
        }
        .onChange(of: inputImage) { _ in
            processInput(inputImage: inputImage)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$inputImage, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
    
    func revealPicker() {
        showSheet = true
    }
    
    func processInput(inputImage: UIImage?) {
        guard let inputImage = inputImage else {
            print("No input image")
            return
        }
        metrics = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            faceDetectionService.isolateFaces(fromCGImage: inputImage.cgImage!)
            DispatchQueue.main.async {
                metrics = faceDetectionService.report()
            }
        }
    }
    
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main().preferredColorScheme(.dark)
    }
}
