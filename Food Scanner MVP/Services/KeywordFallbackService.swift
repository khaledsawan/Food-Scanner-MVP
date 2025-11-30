import Foundation

class KeywordFallbackService: AIService {
    let providerType: AIProviderType = .keywordFallback
    private let porkKeywords = ["pork", "gelatin", "lard", "e120", "bacon", "ham", "pig", "pork fat"]

    func analyze(_ request: AIAnalysisRequest, userAllergens: [String], userRule: String) async throws -> AIAnalysisResult {
        let text = request.ingredientsText.lowercased()
        let foundAllergens = userAllergens.filter { text.contains($0.lowercased()) }
        let foundPork = porkKeywords.contains { text.contains($0) }
        let containsAlcohol = text.contains("alcohol") || text.contains("ethanol")
        let unsafeIngredients: [String] = (foundPork ? ["pork-related"] : []) + foundAllergens
        let safe = !foundPork && foundAllergens.isEmpty && !containsAlcohol
        return AIAnalysisResult(
            containsPork: foundPork,
            containsAlcohol: containsAlcohol,
            allergens: foundAllergens,
            unsafeIngredients: unsafeIngredients,
            analysisNotes: "Keyword fallback: offline detected.",
            isSafeForUser: safe
        )
    }
}
