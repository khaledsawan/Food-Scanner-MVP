import SwiftUI

struct ScanView: View {
  @StateObject private var viewModel = ScanViewModel()
  @State private var showImagePicker = false
  @State private var isAnalyzing = false
  @ObservedObject private var settingsViewModel = SettingsViewModel()

  var busy: Bool { viewModel.isLoading || isAnalyzing }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        if let image = viewModel.selectedImage {
          Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .accessibilityLabel("Selected food label or ingredients image")
        } else {
          VStack(spacing: 8) {
            Image(systemName: "photo.on.rectangle")
              .font(.system(size: 40))
              .foregroundColor(.gray.opacity(0.25))
            Text("Select a food label photo to start")
              .foregroundColor(.gray)
              .font(.callout)
          }
          .frame(height: 120)
        }

        Button("Select Image") {
          showImagePicker = true
        }
        .padding()
        .background(busy ? Color.gray.opacity(0.5) : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .disabled(busy)
        .accessibilityHint("Pick food label or ingredients from your photo library")

        VStack(alignment: .leading, spacing: 6) {
          Text("Ingredients Text (editable):")
            .font(.headline)
          TextEditor(text: $viewModel.extractedText)
            .border(Color.gray.opacity(0.3), width: 1)
            .frame(height: 110)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .accessibilityLabel("Extracted or manual ingredients text")
          if viewModel.extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Text("Enter or extract ingredient text here for analysis.")
              .foregroundColor(.gray)
              .font(.caption)
          }
        }
        .padding(.top, 6)

        Button(action: {
          isAnalyzing = true
          Task {
            let req = AIAnalysisRequest(
              userRule: settingsViewModel.userRule,
              allergenList: settingsViewModel.allergenList,
              ingredientsText: viewModel.extractedText)
            viewModel.providerManager.setSelectedProvider(settingsViewModel.selectedProvider)
            let (result, _) = await viewModel.providerManager.analyzeWithFallback(
              req, userAllergens: settingsViewModel.allergenList,
              userRule: settingsViewModel.userRule
            )
            viewModel.analysisResult = result
            isAnalyzing = false
          }
        }) {
          if isAnalyzing {
            ProgressView().scaleEffect(1.1)
          } else {
            Label("Run Analysis", systemImage: "bolt.shield")
              .bold()
              .frame(maxWidth: .infinity)
          }
        }
        .disabled(
          busy || viewModel.extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        )
        .padding(.vertical, 6)
        .background(busy ? Color.gray.opacity(0.5) : Color.green)
        .foregroundColor(.white)
        .cornerRadius(8)
        .accessibilityLabel("Analyze ingredients for allergens and rules.")

        if let result = viewModel.analysisResult {
          ResultsView(result: result)
            .padding(.horizontal, 6)
            .padding(.top, 8)
        }
        Spacer()
      }
      .padding()
    }
    .overlay(
      Group {
        if busy {
          Color.black.opacity(0.05).ignoresSafeArea()
          VStack(spacing: 16) {
            ProgressView()
            Text(viewModel.isLoading ? "Extracting text..." : "Running analysis...")
              .font(.callout)
              .foregroundColor(.gray)
          }
          .padding(24)
          .background(Color.white.opacity(0.9))
          .cornerRadius(16)
          .shadow(radius: 10)
        }
      }
    )
    .sheet(isPresented: $showImagePicker) {
      ImagePicker(image: $viewModel.selectedImage) { img in
        if let image = img {
          Task {
            await viewModel.processImage(
              image, userAllergens: settingsViewModel.allergenList,
              userRule: settingsViewModel.userRule)
          }
        }
      }
    }
    .alert(item: $viewModel.errorMessage) { error in
      Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
    }
  }
}
