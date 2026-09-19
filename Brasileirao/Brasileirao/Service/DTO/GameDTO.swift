import Foundation

struct GameDTO: Codable {
    let id: Int
    let homeTeam: TeamDTO
    let awayTeam: TeamDTO
    let homeGoals: Int?
    let awayGoals: Int?
    let gameDateTime: Date
    let stadium: String
    let status: GameStatus
    let events: [GameEventDTO]
}
