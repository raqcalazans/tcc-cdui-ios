import Foundation

struct Fan: Codable, Identifiable, Hashable {
    let id: Int
    var name: String
    var email: String
    var birthDate: String
    var gender: String
    var favoriteTeamId: String
    var city: String
    var state: String
    var country: String
    var stadiumFrequency: StadiumFrequency

    var location: String { "\(city), \(state), \(country)" }
}

enum StadiumFrequency: String, Codable, CaseIterable, Identifiable {
    case sempre = "SEMPRE"
    case asVezes = "AS_VEZES"
    case raramente = "RARAMENTE"
    case nunca = "NUNCA"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sempre: "Sempre"
        case .asVezes: "Às vezes"
        case .raramente: "Raramente"
        case .nunca: "Nunca"
        }
    }
}

struct FanPayload: Encodable {
    var name: String
    var email: String
    var birthDate: String
    var gender: String
    var favoriteTeamId: String
    var city: String
    var state: String
    var country: String
    var stadiumFrequency: StadiumFrequency
}
