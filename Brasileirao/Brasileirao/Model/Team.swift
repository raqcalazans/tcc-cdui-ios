import Foundation

final class Team {

    var id: Int
    var name: String
    var acronym: String
    var logoURL: URL
    var teamDescription: String
    var homeGames: [Game]?
    var awayGames: [Game]?
    
    init(
        id: Int,
        name: String,
        acronym: String,
        logoURL: URL,
        teamDescrition: String
    ) {
        self.id = id
        self.name = name
        self.acronym = acronym
        self.logoURL = logoURL
        self.teamDescription = teamDescrition
    }
}
