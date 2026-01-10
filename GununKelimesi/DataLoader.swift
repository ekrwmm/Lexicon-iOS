import Foundation

class DataLoader {
    
    // Kelimeleri yükle
    static func loadWords() -> [Word] {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([Word].self, from: data)
        } catch {
            print("Hata: \(error)")
            return []
        }
    }
    
    // ✨ YENİ: Tarihe Göre Sabit Kelime Seçici
    static func getWordOfTheDay(for date: Date = Date()) -> Word {
        let words = loadWords()
        if words.isEmpty {
            // Acil durum kelimesi (Listede hiç veri yoksa patlamasın)
            return Word(id: 0, term: "Hata", meaning: "Kelime listesi boş.", example: nil)
        }
        
        // 1. Bugün yılın kaçıncı günü? (1...365)
        let cal = Calendar.current
        let dayOfYear = cal.ordinality(of: .day, in: .year, for: date) ?? 1
        
        // 2. Matematiksel Modüler Aritmetik
        // (Gün Sayısı) MOD (Toplam Kelime Sayısı)
        // Örn: 50. gün, 6 kelimemiz varsa -> 50 % 6 = 2. indexteki kelime gelir.
        let index = (dayOfYear - 1) % words.count
        
        return words[index]
    }
}
