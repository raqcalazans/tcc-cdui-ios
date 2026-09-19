import SwiftUI
import Kingfisher

struct GameRowView: View {
    let game: Game

    var body: some View {
        
        if let homeTeam = game.homeTeam, let awayTeam = game.awayTeam {
            
            VStack(spacing: 12) {
                HStack {
                    Text(game.stadium.components(separatedBy: ",").first ?? game.stadium)
                    Text("•")
                    Text(game.gameDateTime.gameDayDisplay)
                    Text("•")
                    Text(game.gameDateTime.gameTimeDisplay)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)

                HStack(spacing: 16) {
                    Text(homeTeam.acronym)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    KFImage(homeTeam.logoURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                    
                    if let homeGoals = game.homeGoals {
                        Text(homeGoals.description)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Text("x")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let awayGoals = game.awayGoals {
                        Text(awayGoals.description)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }

                    KFImage(awayTeam.logoURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)

                    Text(awayTeam.acronym)
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 8)
            
        } else {
            EmptyView()
        }
    }
}

#Preview {
    let homeTeamMock = Team(id: 0,
                            name: "",
                            acronym: "CRU",
                            logoURL: URL(fileURLWithPath: ""),
                            teamDescrition: "")
    
    let awayTeamMock = Team(id: 0,
                            name: "",
                            acronym: "FLA",
                            logoURL: URL(fileURLWithPath: ""),
                            teamDescrition: "")
    
    GameRowView(
        game: Game(id: 0,
                   homeTeam: homeTeamMock,
                   awayTeam: awayTeamMock,
                   homeGoals: 2,
                   awayGoals: 1,
                   gameDateTime: Date(),
                   stadium: "Maracanã",
                   status: GameStatus.finished
                  )
    )
}
