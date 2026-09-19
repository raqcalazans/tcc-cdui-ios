import Foundation

@MainActor
class GameListViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedStatus: GameStatus = .finished
    
    func syncGames() async {
        defer { isLoading = false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let gameDTOs = try await NetworkService.shared.fetchGames()
        } catch {
            errorMessage = "Falha ao sincronizar os jogos: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Filter Logic
    func selectNextStatus() {
        let allStatuses = GameStatus.allCases
        guard let currentIndex = allStatuses.firstIndex(of: selectedStatus) else { return }
        
        let nextIndex = allStatuses.index(after: currentIndex)
        
        selectedStatus = allStatuses.indices.contains(nextIndex) ? allStatuses[nextIndex] : allStatuses.first!
    }
    
    func selectPreviousStatus() {
        let allStatuses = GameStatus.allCases
        guard let currentIndex = allStatuses.firstIndex(of: selectedStatus) else { return }
        
        let previousIndex = allStatuses.index(before: currentIndex)

        selectedStatus = allStatuses.indices.contains(previousIndex) ? allStatuses[previousIndex] : allStatuses.last!
    }
}
