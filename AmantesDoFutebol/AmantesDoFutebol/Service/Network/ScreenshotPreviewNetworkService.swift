#if DEBUG
import Foundation

final class ScreenshotPreviewNetworkService: NetworkServiceProtocol {
    private let sampleFan = Fan(
        id: 1,
        name: "Camila Torres",
        email: "camila.torres@example.com",
        birthDate: "1995-08-14",
        gender: "Feminino",
        favoriteTeamId: "FLA",
        city: "Rio de Janeiro",
        state: "RJ",
        country: "Brasil",
        stadiumFrequency: .asVezes
    )
    private let teams = [
        TeamDTO(id: "FLA", name: "Flamengo"),
        TeamDTO(id: "PAL", name: "Palmeiras"),
        TeamDTO(id: "COR", name: "Corinthians")
    ]

    func fetchTeams() async throws -> [TeamDTO] { teams }
    func fetchFans() async throws -> [Fan] { [sampleFan] }
    func fetchFan(id: Int) async throws -> Fan { sampleFan }
    func createFan(payload: FanPayload) async throws -> Fan { sampleFan }
    func updateFan(id: Int, payload: FanPayload) async throws -> Fan { sampleFan }
    func deleteFan(id: Int) async throws { }
}
#endif
