import Foundation

extension Date {
    
    /// Formata a data para exibição na linha do jogo (ex: "Amanhã", "Hoje", "24/07").
    var gameDayDisplay: String {
        let calendar = Calendar.current
        
        if calendar.isDateInTomorrow(self) {
            return "Amanhã"
        }
        if calendar.isDateInToday(self) {
            return "Hoje"
        }
        if calendar.isDateInYesterday(self) {
            return "Ontem"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: self)
    }
    
    /// Formata a hora para exibição (ex: "19:00").
    var gameTimeDisplay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        // Garante que a hora seja mostrada no fuso horário local do usuário
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}
