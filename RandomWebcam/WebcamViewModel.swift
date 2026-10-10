import Foundation

@MainActor
final class WebcamViewModel: ObservableObject {
    @Published var currentWebcam: Webcam?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api = WebcamAPI()
    private let maxRetries = 3

    func loadRandomWebcam() {
        Task {
            await fetchWithRetries(attempt: 0)
        }
    }

    private func fetchWithRetries(attempt: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let cam = try await api.fetchRandomWebcam()
            currentWebcam = cam
            isLoading = false
        } catch {
            let isMissingKey = (error as? WebcamError) == .missingAPIKey
            if attempt < maxRetries, !isMissingKey {
                try? await Task.sleep(nanoseconds: 400_000_000)
                await fetchWithRetries(attempt: attempt + 1)
            } else {
                isLoading = false
                errorMessage = (error as? WebcamError)?.errorDescription ?? "Не удалось загрузить камеру"
            }
        }
    }
}

// Равенство для WebcamError, чтобы можно было сравнивать случай missingAPIKey выше
extension WebcamError: Equatable {
    static func == (lhs: WebcamError, rhs: WebcamError) -> Bool {
        switch (lhs, rhs) {
        case (.missingAPIKey, .missingAPIKey): return true
        case (.emptyResult, .emptyResult): return true
        default: return false
        }
    }
}
