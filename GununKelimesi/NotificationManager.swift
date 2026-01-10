import Foundation
import UserNotifications

class NotificationManager {
    
    // Uygulamanın her yerinden ulaşabileceğimiz tek yetkili (Singleton)
    static let shared = NotificationManager()
    
    // 1. İZİN İSTEME
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("İzin verildi! Bildirimler kuruluyor...")
                self.scheduleDailyNotification()
            } else if let error = error {
                print("İzin hatası: \(error.localizedDescription)")
            }
        }
    }
    
    // 2. BİLDİRİMİ PLANLAMA
        func scheduleDailyNotification() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            //let kelimeler = DataLoader.loadWords()
            //guard let gununKelimesi = kelimeler.randomElement() else { return }
            
            let gununKelimesi = DataLoader.getWordOfTheDay()
            
            let content = UNMutableNotificationContent()
            content.title = "Lexicon Daily Word: \(gununKelimesi.term)"
            content.body = gununKelimesi.meaning
            content.sound = .default
            
            // --- DEĞİŞİKLİK BURADA ---
            // Eskisi (Sabah 9):
            // var dateComponents = DateComponents()
            // dateComponents.hour = 9
            // dateComponents.minute = 0
            // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // YENİSİ (TEST İÇİN): 5 Saniye sonra ateşle (repeats: false olmalı)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            // -------------------------
            
            let request = UNNotificationRequest(identifier: "gunun_kelimesi_test", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
}
