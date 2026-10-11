import Combine
import Foundation

@MainActor
final class FanListViewModel: ObservableObject {
    @Published private(set) var fans: [Fan] = []
    @Published private(set) var teamNames: [String: String] = [:]
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func loadFans() async {
        isLoading = true
        defer { isLoading = false }

        do {
            fans = try await networkService.fetchFans().sorted { $0.id < $1.id }
            if let teams = try? await networkService.fetchTeams() {
                teamNames = Dictionary(uniqueKeysWithValues: teams.map { ($0.id, $0.name) })
            }
            errorMessage = nil
        } catch {
            errorMessage = "Não foi possível carregar os fãs. Verifique sua conexão e tente novamente."
        }
    }
}
