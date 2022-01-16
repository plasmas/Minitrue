//
//  Main.swift
//  Minitrue
//
//  Created by Yuanqi Wang on 1/15/22.
//

import SwiftUI

struct Main: View {
//    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showPicker = false
    
    private var cs: ClassificationService {
        let newCS = ClassificationService()
        newCS.setup()
        return newCS
    }
    
    var body: some View {
        print(showPicker)
        return VStack {
            ZStack {
                Rectangle()
                    .fill(.secondary)
                
                Text("Tap to select image")
                    .foregroundColor(.white)
                
                if let img = inputImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                }

            }
            .onTapGesture {
                showPicker = true
            }
        }
        .onChange(of: inputImage) { _ in
            infer(inputImage: inputImage)
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func infer(inputImage: UIImage?) {
        guard let inputImage = inputImage else {
            print("No input image")
            return
        }
        let ciImage = CIImage(cgImage: inputImage.cgImage!)
        cs.classify(image: ciImage)
        print(cs.report())
    }
    
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
