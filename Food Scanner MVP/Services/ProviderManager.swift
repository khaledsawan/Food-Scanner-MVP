import Foundation

class ProviderManager {
  private(set) var providers: [AIProviderType: AIService]
  private(set) var providerPriority: [AIProviderType] = [.gemini, .keywordFallback]
  var selectedProvider: AIProviderType {
    didSet { /* persist if needed */  }
  }

  init(providers: [AIProviderType: AIService]? = nil) {
    let defaultProviders: [AIProviderType: AIService] = [
      .gemini: GeminiService(),
      .keywordFallback: KeywordFallbackService(),
    ]
    self.providers = providers ?? defaultProviders
    self.selectedProvider = .gemini
  }

  // Returns (result, providerUsed)
  func analyzeWithFallback(_ request: AIAnalysisRequest, userAllergens: [String], userRule: String)
    async -> (AIAnalysisResult?, AIProviderType)
  {
    // 1. Build a fallback order starting with selected (manual) first
    let fallbackOrder = [selectedProvider] + providerPriority.filter { $0 != selectedProvider }
    var lastError: Error? = nil
    for providerType in fallbackOrder {
      guard let provider = providers[providerType] else { continue }
      do {
        let result = try await provider.analyze(
          request, userAllergens: userAllergens, userRule: userRule)
        return (result, providerType)
      } catch {
        lastError = error
        // On error, fall through and try next provider
      }
    }
    // None succeeded
    return (nil, selectedProvider)
  }

  func setSelectedProvider(_ provider: AIProviderType) {
    selectedProvider = provider
  }
}
