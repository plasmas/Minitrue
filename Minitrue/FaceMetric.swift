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
    let pos: CGRect
    
    init(image: CGImage, gender: String, age: String, emotion: String, pos: CGRect) {
        self.image = image
        self.gender = gender
        self.age = age
        self.emotion = emotion
        self.pos = pos
    }
}
