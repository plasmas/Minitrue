//
//  Metric.swift
//  Minitrue
//
//  Created by Yuanqi Wang on 1/15/22.
//

import Foundation

class Metric: ObservableObject {
    @Published public var gender: String
    @Published public var age: String
    @Published public var emotion: String
    
    init() {
        gender = "Unknown"
        age = "Unknown"
        emotion = "Unknown"
    }
    
    func update(fromResult result: [String?]) {
        if let unwrappedGender = result[0] {
            gender = unwrappedGender
        }
        if let unwrappedAge = result[1] {
            age = unwrappedAge
        }
        if let unwrappedEmotion = result[2] {
            emotion = unwrappedEmotion
        }
    }
}
