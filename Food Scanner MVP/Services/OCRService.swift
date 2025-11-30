import Foundation
import UIKit
import Vision

protocol OCRServiceProtocol {
    func recognizeText(in image: UIImage) async throws -> String
}

class OCRService: OCRServiceProtocol {
    func recognizeText(in image: UIImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = image.cgImage else {
                continuation.resume(
                    throwing: NSError(
                        domain: "OCRService", code: -10,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid Image"]))
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["en"]  // Add more if needed
            do {
                try handler.perform([request])
                guard let observations = request.results else {
                    continuation.resume(returning: "")
                    return
                }
                let resultText = observations.compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")
                continuation.resume(returning: resultText)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
