import SwiftUI

struct AboutView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text("Food Scanner MVP")
          .font(.title)
          .bold()
        Text(
          "Scan and analyze food label ingredients for allergens and dietary rules using your camera or photo library."
        )
        Divider()
        Text("Privacy Notice")
          .font(.headline)
        Text(
          "Your ingredient images are processed for text (OCR) on your device. If you select AI-based analysis, the extracted ingredient text and your preferences are securely sent to cloud providers (Gemini) to analyze ingredients. No personal data or photos are stored."
        )
        Divider()
        Text("Get Started:")
          .font(.headline)
        Text(
          "- Tap 'Scan' to pick a photo and extract ingredients.\n- Edit your settings for allergens, diet, and provider.\n- Tap 'Run Analysis' for an evaluation."
        )
        Spacer(minLength: 30)
        Text("App version 1.0.0")
          .font(.footnote)
          .foregroundColor(.gray)
      }
      .padding()
    }
  }
}
