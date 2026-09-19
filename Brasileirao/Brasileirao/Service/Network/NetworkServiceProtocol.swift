import Foundation

protocol NetworkServiceProtocol {
    
    func fetchGames() async throws -> [GameDTO]
    func fetchTeams() async throws -> [TeamDTO]
    func submitFanRegistration(endpoint: String, data: [String: String]) async throws
}
