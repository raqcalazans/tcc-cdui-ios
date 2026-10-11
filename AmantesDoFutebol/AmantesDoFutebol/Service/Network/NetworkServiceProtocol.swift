import Foundation

protocol NetworkServiceProtocol {
    func fetchTeams() async throws -> [TeamDTO]
    func fetchFans() async throws -> [Fan]
    func fetchFan(id: Int) async throws -> Fan
    func createFan(payload: FanPayload) async throws -> Fan
    func updateFan(id: Int, payload: FanPayload) async throws -> Fan
    func deleteFan(id: Int) async throws
}
