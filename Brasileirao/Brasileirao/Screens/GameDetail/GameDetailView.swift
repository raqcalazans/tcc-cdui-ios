import SwiftUI

struct GameDetailView: View {
    
    @StateObject private var viewModel: GameDetailViewModel
    
    init(game: Game) {
        _viewModel = StateObject(wrappedValue: GameDetailViewModel(game: game))
    }
    
    var body: some View {
        List {
            Section {
                GameRowView(game: viewModel.game)
            }
            
            if viewModel.hasEvents {
                Section(header: Text("Lance a Lance")) {
                    ForEach(viewModel.game.events.sorted(by: { $0.timeInGame < $1.timeInGame })) { event in
                        GameEventRowView(event: event)
                            .listRowSeparator(.hidden) // Esconde o separador para a linha do tempo funcionar
                    }
                }
            } else {
                // Caso 2: O jogo não tem eventos (mostra descrição dos times)
                Section(header: Text("Sobre os Times")) {
                    // Usamos 'if let' para desempacotar os times com segurança
                    if let homeTeam = viewModel.game.homeTeam {
                        TeamDescriptionView(team: homeTeam)
                    }
                    if let awayTeam = viewModel.game.awayTeam {
                        TeamDescriptionView(team: awayTeam)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Detalhes da Partida")
        .navigationBarTitleDisplayMode(.inline)
    }
}
