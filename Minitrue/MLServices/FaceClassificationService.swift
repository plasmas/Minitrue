import CoreML
import Vision
import VisionLab

/// Delegate protocol used for `ClassificationService`
//protocol ClassificationServiceDelegate: AnyObject {
//    func classificationService(_ service: ClassificationService, didDetectGender gender: String)
//    func classificationService(_ service: ClassificationService, didDetectAge age: String)
//    func classificationService(_ service: ClassificationService, didDetectEmotion emotion: String)
//}

/// Service used to perform gender, age and emotion classification
final class ClassificationService: ClassificationServiceProtocol {
    /// The service's delegate
//    weak var delegate: ClassificationServiceDelegate?
    private var gender: String?
    private var age: String?
    private var emotion: String?
    
    /// Array of vision requests
    private var requests = [VNRequest]()
    
    /// Create CoreML model and classification requests
    func setup() {
        do {
            // Gender request
            requests.append(VNCoreMLRequest(
                model: try VNCoreMLModel(for: GenderNet(configuration: MLModelConfiguration()).model),
                completionHandler: handleGenderClassification
            ))
            // Age request
            requests.append(VNCoreMLRequest(
                model: try VNCoreMLModel(for: AgeNet(configuration: MLModelConfiguration()).model),
                completionHandler: handleAgeClassification
            ))
            // Emotions request
            requests.append(VNCoreMLRequest(
                model: try VNCoreMLModel(for: CNNEmotions(configuration: MLModelConfiguration()).model),
                completionHandler: handleEmotionClassification
            ))
        } catch {
            assertionFailure("Can't load Vision ML model: \(error)")
        }
    }
    
    /// Run individual requests one by one.
    func classify(image: CIImage) -> [String?] {
        do {
            for request in self.requests {
                let handler = VNImageRequestHandler(ciImage: image)
                try handler.perform([request])
            }
            return [gender, age, emotion]
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - Handling
    @objc private func handleGenderClassification(request: VNRequest, error: Error?) {
        gender = extractClassificationResult(from: request, count: 1)
//        delegate?.classificationService(self, didDetectGender: result)
    }
    
    @objc private func handleAgeClassification(request: VNRequest, error: Error?) {
        age = extractClassificationResult(from: request, count: 1)
//        delegate?.classificationService(self, didDetectAge: result)
    }
    
    @objc private func handleEmotionClassification(request: VNRequest, error: Error?) {
        emotion = extractClassificationResult(from: request, count: 1)
//        delegate?.classificationService(self, didDetectEmotion: result)
    }
}
