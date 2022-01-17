//
//  FaceDetectionService.swift
//  Minitrue
//
//  Created by Yuanqi Wang on 1/16/22.
//

import Foundation
import CoreImage
import Vision

class FaceDetectionService {
    
    private var cs: ClassificationService {
        let newCS = ClassificationService()
        newCS.setup()
        return newCS
    }
    
    private var metrics: [FaceMetric]?
    private var image: CGImage?
    
    private func handleDetectedRectangles(request: VNRequest?, error: Error?) {
        if let nsError = error as NSError? {
            print("Face detection Error: \(nsError.localizedDescription)")
            return
        }
        guard let results = request?.results as? [VNFaceObservation] else { return }
        
        var newMetrics = [FaceMetric]()
        
        let width = CGFloat(image!.width)
        let height = CGFloat(image!.height)
        
        for observation in results {
            let faceWidth = width * observation.boundingBox.width
            let faceHeight = height * observation.boundingBox.height
            let faceX = width * observation.boundingBox.origin.x
            let faceY = height - height * observation.boundingBox.origin.y - faceHeight

            if let croppedImage = image?.cropping(to: CGRect(x: faceX, y: faceY, width: faceWidth, height: faceHeight)) {
                let res = cs.classify(image: CIImage(cgImage: croppedImage))
                if let gender = res[0], let age = res[1], let emotion = res[2] {
                    newMetrics.append(FaceMetric(image: croppedImage, gender: gender, age: age, emotion: emotion))
                }
            }
        }
        metrics = newMetrics
    }
    
    public func isolateFaces(fromCGImage cgImage: CGImage) {
        image = cgImage
        let imageRequestHandler = VNImageRequestHandler(cgImage: image!, orientation: .up, options: [:])
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleDetectedRectangles)
        
        #if targetEnvironment(simulator)
        faceDetectionRequest.usesCPUOnly = true
        #endif
        
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch let error as NSError {
            print(error)
            return
        }
    }
    
    public func report() -> [FaceMetric]? {
        return metrics
    }
}
