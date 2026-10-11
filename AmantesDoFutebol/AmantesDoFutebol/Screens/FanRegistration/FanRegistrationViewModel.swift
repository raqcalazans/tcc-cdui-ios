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
        birthDate = FanBirthDateFormatter.display(fan?.birthDate ?? "")
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
            if favoriteTeamId.isEmpty, let first = teams.first {
                favoriteTeamId = first.id
            }
        } catch {
            errorMessage = "Não foi possível carregar os times. Tente novamente."
        }
    }

    func updateBirthDateInput(_ input: String) {
        let digits = String(input.filter(\.isNumber).prefix(8))
        var formatted = ""
        for (index, digit) in digits.enumerated() {
            if index == 2 || index == 4 { formatted.append("/") }
            formatted.append(digit)
        }
        birthDate = formatted
    }

    func save() async throws {
        isLoading = true
        defer { isLoading = false }

        let payload = FanPayload(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDate: FanBirthDateFormatter.storage(birthDate.trimmingCharacters(in: .whitespacesAndNewlines)),
            gender: gender.trimmingCharacters(in: .whitespacesAndNewlines),
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
