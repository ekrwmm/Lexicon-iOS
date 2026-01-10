import SwiftUI

struct ContentView: View {
    // DataLoader'ı kullanarak kelimeleri yükle
    var kelimeler: [Word] = DataLoader.loadWords()
    
    var body: some View {
        VStack {
            Text("Lexicon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Listeleme yapıyoruz
            List(kelimeler) { kelime in
                VStack(alignment: .leading, spacing: 5) {
                    Text(kelime.term)
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    Text(kelime.meaning)
                        .font(.body)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    ContentView()
}
