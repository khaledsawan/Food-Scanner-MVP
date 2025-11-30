# 🔍 Food Scanner MVP

A smart iOS application that helps users make informed dietary choices by analyzing food labels instantly. Using advanced OCR technology and AI-powered analysis, Food Scanner MVP identifies allergens, dietary compliance, and safety concerns with a single photo.

## ✨ Features

### 📸 Smart Image Recognition
- **Instant OCR**: Capture food label photos and automatically extract ingredient text using Vision Framework
- **High Accuracy**: Utilizes iOS's native Vision framework with language correction for reliable text extraction
- **Editable Results**: Manual correction or direct text input for ingredients

### 🤖 AI-Powered Analysis
- **Multi-Provider Support**: Leverages Google Gemini 2.5 Flash for intelligent ingredient analysis
- **Comprehensive Safety Assessment**: Identifies:
  - ❌ Pork and alcohol derivatives
  - ⚠️ Common allergens
  - 🚫 Unsafe ingredients based on user preferences
  - ✅ Dietary rule compliance

### 🎯 Personalized Dietary Rules
- **Custom Preferences**: Support for multiple dietary rules (Halal, Vegan, Vegetarian, Keto, Sugar-Free, etc.)
- **Allergen Management**: Create and manage personal allergen lists
- **Real-Time Compliance Checking**: Instant verification against your dietary constraints

### 🔐 Privacy & Security
- **Firebase Integration**: Secure authentication and data handling
- **Local Processing**: Image processing happens on-device for privacy
- **No Cloud Storage**: Your dietary preferences stay with you

## 🏗️ Architecture

### Technology Stack
- **Language**: Swift
- **UI Framework**: SwiftUI
- **OCR**: Vision Framework (Apple's native solution)
- **AI/ML**: Google Gemini 2.5 Flash via Firebase AI Logic
- **Backend**: Firebase (Authentication & Configuration)
- **Storage**: UserDefaults (Local preferences)

### Key Components

#### Services
- **OCRService**: Handles image text recognition with language correction
- **GeminiService**: AI-powered ingredient analysis and safety assessment
- **AIService Protocol**: Abstraction for multiple AI providers
- **ProviderManager**: Manages multiple AI providers with fallback support
- **KeywordFallbackService**: Backup analysis when primary providers fail

#### ViewModels
- **ScanViewModel**: Manages image selection, OCR processing, and analysis state
- **SettingsViewModel**: Handles user preferences (dietary rules, allergens, AI provider selection)
- **ResultsViewModel**: Manages analysis results display logic

#### Views
- **ScanView**: Main interface for image selection and analysis
- **ResultsView**: Displays comprehensive safety assessment
- **SettingsView**: Manage dietary preferences and AI provider
- **AboutView**: Application information and guidance

## 🚀 Getting Started

### Prerequisites
- iOS 14.0 or later
- Xcode 15.0+
- CocoaPods (for dependency management)

### Installation

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd "Food Scanner MVP"
   ```

2. **Install Dependencies**
   ```bash
   pod install
   ```

3. **Firebase Setup**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to the Xcode project (replace existing file)
   - Ensure Firebase AI Logic is configured

4. **Build & Run**
   - Open `Food Scanner MVP.xcworkspace` in Xcode
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 📖 How to Use

1. **Open the App** → Navigate to the Scan tab
2. **Select Image** → Tap "Select Image" to choose a food label photo
3. **Review Text** → OCR automatically extracts ingredients (editable)
4. **Set Preferences** → Configure your dietary rule and allergens in settings
5. **Run Analysis** → Tap "Run Analysis" to check safety
6. **Review Results** → See detailed findings with specific warnings and notes

### Example Scenarios
- **Halal User**: Detects pork, alcohol, and non-halal ingredients
- **Vegan User**: Identifies animal products (dairy, eggs, gelatin, honey)
- **Allergy Sufferer**: Flags specific allergens and cross-contamination risks
- **Health-Conscious**: Checks for sugar, additives, or other restrictions

## 🔍 Analysis Output

Each analysis returns:
```json
{
  "containsPork": boolean,
  "containsAlcohol": boolean,
  "allergens": ["string"],
  "unsafeIngredients": ["string"],
  "analysisNotes": "string",
  "isSafeForUser": boolean
}
```

## 🛡️ Safety & Privacy

- **On-Device Processing**: Images are processed locally; only ingredients text is sent to AI
- **User Control**: You control which AI provider to use
- **No Tracking**: Application respects user privacy
- **Fallback System**: If primary AI fails, keyword-based fallback ensures functionality


## 🐛 Known Issues

- OCR accuracy varies based on image quality and label clarity
- Complex ingredient lists may require manual correction
- Language support currently limited to English

## 🙏 Acknowledgments

- Google Gemini team for AI analysis capabilities
- Apple Vision Framework documentation
- Firebase team for backend infrastructure
- The open-source community for inspiration and support
