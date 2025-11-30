import Combine
import Foundation

private enum SettingsKeys: String {
  case selectedProvider, allergenList, userRule, geminiKey
}

class SettingsViewModel: ObservableObject {
  @Published var selectedProvider: AIProviderType = .gemini {
    didSet {
      UserDefaults.standard.set(
        selectedProvider.rawValue, forKey: SettingsKeys.selectedProvider.rawValue)
    }
  }
  @Published var allergenList: [String] = [] {
    didSet { UserDefaults.standard.set(allergenList, forKey: SettingsKeys.allergenList.rawValue) }
  }
  @Published var userRule: String = "" {
    didSet { UserDefaults.standard.set(userRule, forKey: SettingsKeys.userRule.rawValue) }
  }
  @Published var geminiKey: String = "" {
    didSet { UserDefaults.standard.set(geminiKey, forKey: SettingsKeys.geminiKey.rawValue) }
  }

  init() {
    if let pRaw = UserDefaults.standard.string(forKey: SettingsKeys.selectedProvider.rawValue),
      let provider = AIProviderType(rawValue: pRaw)
    {
      self.selectedProvider = provider
    }
    if let allergens = UserDefaults.standard.stringArray(forKey: SettingsKeys.allergenList.rawValue)
    {
      self.allergenList = allergens
    }
    self.userRule = UserDefaults.standard.string(forKey: SettingsKeys.userRule.rawValue) ?? ""
    self.geminiKey = UserDefaults.standard.string(forKey: SettingsKeys.geminiKey.rawValue) ?? ""
  }

  func addAllergen(_ allergen: String) {
    let new = allergen.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !new.isEmpty, !allergenList.contains(new) else { return }
    allergenList.append(new)
  }
  func removeAllergen(_ allergen: String) {
    allergenList.removeAll { $0 == allergen }
  }
}
