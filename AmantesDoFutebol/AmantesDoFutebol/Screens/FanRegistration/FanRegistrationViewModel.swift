import Combine
import Foundation

@MainActor
final class FanRegistrationViewModel: ObservableObject {
    static let genderOptions = ["Feminino", "Masculino", "Não Binário"]

    @Published var name: String
    @Published var email: String
    @Published var birthDate: String
    @Published var gender: String
    @Published var favoriteTeamId: String
    @Published var city: String
    @Published var state: String
    @Published var country: String
    @Published var stadiumFrequency: StadiumFrequency
    @Published private(set) var teams: [TeamDTO] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let fan: Fan?
    private let networkService: NetworkServiceProtocol

    var isEditing: Bool { fan != nil }

    init(fan: Fan? = nil, networkService: NetworkServiceProtocol = NetworkService()) {
        self.fan = fan
        self.networkService = networkService
        name = fan?.name ?? ""
        email = fan?.email ?? ""
        birthDate = FanDateFormatter.display(fan?.birthDate ?? "")
        gender = fan?.gender ?? ""
        favoriteTeamId = fan?.favoriteTeamId ?? ""
        city = fan?.city ?? ""
        state = fan?.state ?? ""
        country = fan?.country ?? ""
        stadiumFrequency = fan?.stadiumFrequency ?? .nunca
    }

    func loadTeams() async {
        do {
            teams = try await networkService.fetchTeams()
            guard !teams.isEmpty else {
                errorMessage = "Não há times disponíveis para seleção."
                return
            }
            if favoriteTeamId.isEmpty, let first = teams.first {
                favoriteTeamId = first.id
            }
        } catch {
            errorMessage = "Não foi possível carregar os times. Tente novamente."
        }
    }

    func updateBirthDateInput(_ input: String) {
        birthDate = FanDateFormatter.mask(input)
    }

    func save() async throws {
        isLoading = true
        defer { isLoading = false }

        let requiredValues = [name, email, birthDate, gender, favoriteTeamId, city, state, country]
        guard requiredValues.allSatisfy({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            throw FanFormError.missingRequiredFields
        }
        guard !teams.isEmpty else { throw FanFormError.teamsUnavailable }
        guard teams.contains(where: { $0.id == favoriteTeamId }) else { throw FanFormError.invalidFavoriteTeam }
        let normalizedGender = gender.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Self.genderOptions.contains(normalizedGender) else { throw FanFormError.invalidGender }

        let displayedBirthDate = birthDate.trimmingCharacters(in: .whitespacesAndNewlines)
        let storedBirthDate = FanDateFormatter.storage(displayedBirthDate)
        guard displayedBirthDate.count == 10, storedBirthDate != displayedBirthDate else {
            throw FanFormError.invalidBirthDate
        }

        let payload = FanPayload(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDate: storedBirthDate,
            gender: normalizedGender,
            favoriteTeamId: favoriteTeamId,
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            state: state.trimmingCharacters(in: .whitespacesAndNewlines),
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
            stadiumFrequency: stadiumFrequency
        )

        if let fan {
            _ = try await networkService.updateFan(id: fan.id, payload: payload)
        } else {
            _ = try await networkService.createFan(payload: payload)
        }
    }

}


enum FanFormError: LocalizedError {
    case missingRequiredFields
    case invalidBirthDate
    case teamsUnavailable
    case invalidFavoriteTeam
    case invalidGender

    var errorDescription: String? {
        switch self {
        case .missingRequiredFields: "Preencha todos os campos obrigatórios."
        case .invalidBirthDate: "Informe uma data válida no formato DD/MM/AAAA."
        case .teamsUnavailable: "Não foi possível carregar os times. Tente novamente."
        case .invalidFavoriteTeam: "Selecione um time disponível."
        case .invalidGender: "Selecione uma opção de gênero válida."
        }
    }
}
