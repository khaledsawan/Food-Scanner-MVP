import SwiftUI

struct SettingsView: View {
  @StateObject private var viewModel = SettingsViewModel()
  @State private var newAllergen = ""

  var body: some View {
    Form {
      Section(header: Text("AI Provider")) {
        Picker("AI Provider", selection: $viewModel.selectedProvider) {
          ForEach(AIProviderType.allCases) { provider in
            Text(provider.rawValue.capitalized).tag(provider)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }

      Section(header: Text("Allergens")) {
        HStack {
          TextField("Add Allergen", text: $newAllergen)
            .autocapitalization(.none)
          Button(action: {
            viewModel.addAllergen(newAllergen)
            newAllergen = ""
          }) {
            Image(systemName: "plus.circle.fill")
              .foregroundColor(.green)
          }
          .disabled(newAllergen.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        ForEach(viewModel.allergenList, id: \.self) { allergen in
          HStack {
            Text(allergen)
            Spacer()
            Button(action: { viewModel.removeAllergen(allergen) }) {
              Image(systemName: "minus.circle")
                .foregroundColor(.red)
            }
          }
        }
      }

      Section(header: Text("Dietary Rule")) {
        TextField("e.g. Halal, Vegan...", text: $viewModel.userRule)
      }

      Section(header: Text("API Keys")) {
        SecureField("Gemini API Key", text: $viewModel.geminiKey)
      }
    }
  }
}
