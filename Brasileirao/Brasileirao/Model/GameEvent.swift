import Foundation

final class GameEvent: Identifiable {

    var id: Int
    var timeInGame: String
    var eventDescription: String
    var game: Game?
    
    init(id: Int, timeInGame: String, eventDescription: String) {
        self.id = id
        self.timeInGame = timeInGame
        self.eventDescription = eventDescription
    }
}
