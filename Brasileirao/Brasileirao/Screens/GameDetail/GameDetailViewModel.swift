import Foundation
import SwiftUI

@MainActor
class GameDetailViewModel: ObservableObject {
    
    // A view irá observar esta propriedade. Se ela mudar, a view se reconstrói.
    @Published private(set) var game: Game
    
    /// Propriedade computada que a View usará para decidir o que renderizar.
    var hasEvents: Bool {
        return !game.events.isEmpty
    }
    
    init(game: Game) {
        self.game = game
    }
}
