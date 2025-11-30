import Foundation
import Combine

class ResultsViewModel: ObservableObject {
    @Published var result: AIAnalysisResult?
    
    init(result: AIAnalysisResult? = nil) {
        self.result = result
    }
}
