//
//  Exercise.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var duration: Int // in seconds
    
    init(id: UUID = UUID(), name: String, duration: Int) {
        self.id = id
        self.name = name
        self.duration = duration
    }
}

