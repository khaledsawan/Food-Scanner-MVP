import Foundation

enum AIProviderType: String, CaseIterable, Identifiable {
  case gemini, keywordFallback
  var id: String { self.rawValue }
}

struct AIAnalysisRequest {
  let userRule: String
  let allergenList: [String]
  let ingredientsText: String
}

struct AIAnalysisResult: Codable {
  let containsPork: Bool?
  let containsAlcohol: Bool?
  let allergens: [String]
  let unsafeIngredients: [String]
  let analysisNotes: String
  let isSafeForUser: Bool?
}

protocol AIService {
  var providerType: AIProviderType { get }
  func analyze(_ request: AIAnalysisRequest, userAllergens: [String], userRule: String) async throws
    -> AIAnalysisResult
}
