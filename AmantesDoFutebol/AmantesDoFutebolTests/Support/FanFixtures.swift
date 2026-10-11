@testable import AmantesDoFutebol

enum FanFixtures {
    static func make(id: Int = 4, favoriteTeamId: String = "FLA") -> Fan {
        Fan(id: id, name: "Ana", email: "ana@example.com", birthDate: "1990-01-02", gender: "Feminino", favoriteTeamId: favoriteTeamId, city: "São Paulo", state: "SP", country: "Brasil", stadiumFrequency: .sempre)
    }
}
