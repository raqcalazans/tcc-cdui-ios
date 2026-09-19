enum GameStatus: String, Codable, CaseIterable {
    case finished = "FINALIZADO"
    case live = "AO_VIVO"
    case scheduled = "AGENDADO"

    var title: String {
        switch self {
        case .finished:
            return "ENCERRADOS"
        case .live:
            return "AO VIVO"
        case .scheduled:
            return "AGENDADOS"
        }
    }
}
