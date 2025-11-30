import Foundation
import UIKit
import Combine

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

@MainActor
class ScanViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var extractedText: String = ""
    @Published var analysisResult: AIAnalysisResult?
    @Published var errorMessage: ErrorMessage?
    @Published var settingsViewModel = SettingsViewModel()

    var isLoading: Bool = false
    var ocrService: OCRServiceProtocol
    var providerManager: ProviderManager
    
    init(ocrService: OCRServiceProtocol = OCRService(), providerManager: ProviderManager = ProviderManager()) {
        self.ocrService = ocrService
        self.providerManager = providerManager
    }
    
    func processImage(_ image: UIImage, userAllergens: [String]? = nil, userRule: String? = nil) async {
        guard !isLoading else { return }
        selectedImage = image
        isLoading = true
        defer { isLoading = false }
        do {
            let text = try await ocrService.recognizeText(in: image)
            extractedText = text
            let req = AIAnalysisRequest(
                userRule: userRule ?? settingsViewModel.userRule,
                allergenList: userAllergens ?? settingsViewModel.allergenList,
                ingredientsText: text)
            let (result, _) = await providerManager.analyzeWithFallback(req,
                userAllergens: req.allergenList,
                userRule: req.userRule)
            self.analysisResult = result
        } catch {
            self.errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }
}
