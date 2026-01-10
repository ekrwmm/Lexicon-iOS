import WidgetKit
import SwiftUI

// 1. TIMELINE PROVIDER (MOTOR)
// Widget'ın ne zaman güncelleneceğini ve hangi veriyi göstereceğini yönetir.
struct Provider: TimelineProvider {
    
    // Widget galerisinde (seçim ekranında) görünecek sahte veri
    func placeholder(in context: Context) -> SimpleEntry {
        // Galeride rastgele bir kelime gösterelim
        let ornekKelime = DataLoader.loadWords().first!
        return SimpleEntry(date: Date(), word: ornekKelime)
    }

    // Widget anlık görüntüsü (Snapshot) istendiğinde çalışır
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let ornekKelime = DataLoader.loadWords().randomElement()!
        let entry = SimpleEntry(date: Date(), word: ornekKelime)
        completion(entry)
    }

    // ASIL OLAY BURASI: Zaman tüneli (Timeline) oluşturur
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
            var entries: [SimpleEntry] = []
            let currentDate = Date()
            
            // ❌ ESKİSİ: Rastgele seçiyordu
            // let kelimeler = DataLoader.loadWords()
            // let secilenKelime = kelimeler.randomElement() ...
            
            // ✅ YENİSİ: Tarihe göre sabit kelime
            let gununKelimesi = DataLoader.getWordOfTheDay(for: currentDate)
            
            // Girişi oluştur
            let entry = SimpleEntry(date: currentDate, word: gununKelimesi)
            entries.append(entry)

            // Güncelleme Zamanı: Yarın gece yarısı (00:00)
            // Widget her gün tam gece yarısı yeni kelimeye dönsün.
            let calendar = Calendar.current
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            let startOfTomorrow = calendar.startOfDay(for: tomorrow)
            
            let timeline = Timeline(entries: entries, policy: .after(startOfTomorrow))
            completion(timeline)
        }
}

// 2. ENTRY (VERİ PAKETİ)
// Widget'ın ekrana basacağı veriyi taşıyan kutu.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let word: Word // Bizim kelime modelimiz
}

// 3. VIEW (TASARIM)
// Widget'ın ekranda nasıl görüneceğini çizen yer.
// 3. VIEW (TASARIM - GÜNCELLENMİŞ VERSİYON)
struct SozlukWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryRectangular:
            // KİLİT EKRANI (DİKDÖRTGEN)
            VStack(alignment: .leading, spacing: 1) { // Boşlukları azalttık (spacing: 1)
                Text(entry.word.term)
                    .font(.headline)
                    .bold()
                    // Yazı sığmazsa %60'a kadar küçülmesine izin ver
                    .minimumScaleFactor(0.6)
                
                Text(entry.word.meaning)
                    .font(.system(size: 13)) // Biraz daha küçük punto
                    .lineLimit(3) // 3 satıra kadar izin ver
                    .multilineTextAlignment(.leading)
                    // Yazı sığmazsa %50'ye kadar küçülmesine izin ver
                    .minimumScaleFactor(0.5)
            }
            // Tüm alanı sola yaslı kullanması için
            .frame(maxWidth: .infinity, alignment: .leading)
            
        case .systemSmall:
            // ANA EKRAN KÜÇÜK WIDGET
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.word.term)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.blue)
                    .minimumScaleFactor(0.7)
                
                Text(entry.word.meaning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.7)
            }
            .padding()
            
        default:
            Text("Bilinmeyen")
        }
    }
}

// 4. WIDGET CONFIGURATION (AYARLAR)
@main
struct SozlukWidget: Widget {
    let kind: String = "SozlukWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SozlukWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Lexicon Widget")
        .description("Learn a new word every day with Lexicon.")
        // Hangi boyutları destekliyoruz? (Kilit ekranı dikdörtgen + Ana ekran küçük)
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

// PREVIEW (CANVAS İÇİN)
#Preview(as: .systemSmall) {
    SozlukWidget()
} timeline: {
    SimpleEntry(date: .now, word: DataLoader.loadWords()[0])
}
