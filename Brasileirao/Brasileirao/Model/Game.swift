import Foundation

final class Game {
    
    var id: Int
    var homeGoals: Int?
    var awayGoals: Int?
    var gameDateTime: Date
    var stadium: String
    var statusRawValue: String
    var status: GameStatus {
        get {
            GameStatus(rawValue: statusRawValue) ?? .scheduled
        }
        set {
            statusRawValue = newValue.rawValue
        }
    }
    var homeTeam: Team?
    var awayTeam: Team?
    var events: [GameEvent] = []
    
    init(
        id: Int,
        homeTeam: Team,
        awayTeam: Team,
        homeGoals: Int? = nil,
        awayGoals: Int? = nil,
        gameDateTime: Date,
        stadium: String,
        status: GameStatus
    ) {
        self.id = id
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeGoals = homeGoals
        self.awayGoals = awayGoals
        self.gameDateTime = gameDateTime
        self.stadium = stadium
        self.statusRawValue = status.rawValue
    }
}
