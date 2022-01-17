//
//  FaceMetric.swift
//  Minitrue
//
//  Created by Yuanqi Wang on 1/16/22.
//

import Foundation
import Vision
import CoreImage

class FaceMetric: Identifiable {
    
    let id = UUID()

    let gender: String
    let age: String
    let emotion: String
    
    let image: CGImage
    
    init(image: CGImage, gender: String, age: String, emotion: String) {
        self.image = image
        self.gender = gender
        self.age = age
        self.emotion = emotion
    }
}
