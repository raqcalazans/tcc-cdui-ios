import Foundation
import Combine

@MainActor
class FanRegistrationViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var teams: [TeamDTO] = []
    @Published var selectedTeamID: Int?
    @Published var subscriptionPlan: String = "Basic"
    @Published var receivesAlerts: Bool = false
    
    @Published var isLoading = false
    @Published var isSubmitted = false
    @Published var errorMessage: String?

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func loadTeams() {
        Task {
            do {
                self.teams = try await networkService.fetchTeams()
            } catch {
                self.errorMessage = "Erro ao carregar equipas: \(error.localizedDescription)"
            }
        }
    }

    func submitRegistration() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let payload: [String: String] = [
                    "name": name,
                    "email": email,
                    "favoriteTeamId": "\(selectedTeamID ?? 0)",
                    "subscriptionPlan": subscriptionPlan,
                    "receivesAlerts": "\(receivesAlerts)"
                ]
                
                try await networkService.submitFanRegistration(endpoint: "/fans", data: payload)
                isSubmitted = true
            } catch {
                self.errorMessage = "Erro ao submeter cadastro: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
