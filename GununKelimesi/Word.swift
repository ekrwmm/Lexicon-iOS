//
//  Word.swift
//  GununKelimesi
//
//  Created by ekrem emre büyükcoşkun on 11.01.2026.
//

import Foundation

struct Word: Codable, Identifiable {
    let id: Int
    let term: String // kelime
    let meaning: String  // anlamı
    let example: String?  // ornek cumle 
}
