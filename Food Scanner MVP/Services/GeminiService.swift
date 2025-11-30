import Foundation
import FirebaseAILogic

class GeminiService: AIService {
  let providerType: AIProviderType = .gemini

  func analyze(_ request: AIAnalysisRequest, userAllergens: [String], userRule: String) async throws
    -> AIAnalysisResult
  {
      let ai = FirebaseAI.firebaseAI(backend: .googleAI())
    let model = ai.generativeModel(modelName: "gemini-2.5-flash")

    let systemPrompt = """
      You are an expert Food Safety and Dietary Analyzer Agent.
      Your goal is to analyze food ingredients and labels to determine safety based on user constraints.

      Input:
      - User Rule (e.g., 'Halal', 'Vegan')
      - User Allergens (e.g., 'Peanuts')
      - Scanned Text (OCR output)

      Output:
      Return ONLY a valid JSON object with this structure:
      {
        "containsPork": boolean,
        "containsAlcohol": boolean,
        "allergens": string[],
        "unsafeIngredients": string[],
        "analysisNotes": string,
        "isSafeForUser": boolean
      }

      Guidelines:
      - Identify pork/alcohol derivatives.
      - Cross-reference with User Allergens.
      - Check compliance with User Rule.
      - If text is unclear/garbled, set isSafeForUser: false and explain in notes.
      - Be conservative: if ambiguous, flag as unsafe.
      """
    let userPrompt =
      "User rule: \(request.userRule)\nUser allergens: \(request.allergenList.joined(separator: ", "))\nIngredients text: \(request.ingredientsText)"

    let prompt = systemPrompt + "\n" + userPrompt

    do {
      let response = try await model.generateContent(prompt)
      guard let text = response.text else {
        throw NSError(
          domain: "GeminiService", code: -3,
          userInfo: [NSLocalizedDescriptionKey: "Gemini returned no text content!"])
      }

      // Clean up potential markdown code blocks if present (e.g. ```json ... ```)
      let cleanText = text.replacingOccurrences(of: "```json", with: "").replacingOccurrences(
        of: "```", with: "")

      let jsonData = cleanText.data(using: .utf8) ?? Data()
      let result = try JSONDecoder().decode(AIAnalysisResult.self, from: jsonData)

      return AIAnalysisResult(
        containsPork: result.containsPork,
        containsAlcohol: result.containsAlcohol,
        allergens: result.allergens,
        unsafeIngredients: result.unsafeIngredients,
        analysisNotes: "Provider: Gemini (Firebase)\n" + result.analysisNotes,
        isSafeForUser: result.isSafeForUser
      )
    } catch {
      throw NSError(
        domain: "GeminiService", code: -1,
        userInfo: [
          NSLocalizedDescriptionKey: "Gemini Analysis Failed: \(error.localizedDescription)"
        ])
    }
  }
}
