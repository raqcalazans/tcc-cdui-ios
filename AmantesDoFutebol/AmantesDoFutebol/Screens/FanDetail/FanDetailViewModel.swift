import Combine
import Foundation

@MainActor
final class FanDetailViewModel: ObservableObject {
    @Published private(set) var fan: Fan
    @Published private(set) var favoriteTeamName: String
    @Published var errorMessage: String?

    var formattedBirthDate: String { FanDateFormatter.display(fan.birthDate) }
    var ageDescription: String {
        guard let age = FanDateFormatter.age(from: fan.birthDate) else { return "—" }
        return age == 1 ? "1 ano" : "\(age) anos"
    }

    private let networkService: NetworkServiceProtocol

    init(fan: Fan, networkService: NetworkServiceProtocol = NetworkService()) {
        self.fan = fan
        favoriteTeamName = fan.favoriteTeamId
        self.networkService = networkService
    }

    func refresh() async {
        do {
            fan = try await networkService.fetchFan(id: fan.id)
            if let teams = try? await networkService.fetchTeams(),
               let team = teams.first(where: { $0.id == fan.favoriteTeamId }) {
                favoriteTeamName = team.name
            }
            errorMessage = nil
        } catch {
            errorMessage = "Não foi possível atualizar os dados deste fã."
        }
    }

    func delete() async throws {
        try await networkService.deleteFan(id: fan.id)
    }
}
