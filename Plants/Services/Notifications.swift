//
//  Notifications.swift
//  Plants
//
//  Created by Alex Daniel on 4/25/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import UserNotifications

struct Notifications {
    static func water(plant: Plant) {
        guard plant.waterFrequency > 0, let uuid = plant.id else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Hello 👋"
        content.body = "\(plant.name ?? "A plant") would like some attention. 🌱"
        content.sound = UNNotificationSound.default
        
        let frequency = TimeInterval(plant.waterFrequency) * 24 * 60 * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: frequency, repeats: true)

        // choose a random identifier
        let id = "\(uuid.uuidString)-water-frequency"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    static func cancelReminder(plant: Plant) {
        guard let uuid = plant.id else {
            return
        }
        
        let id = "\(uuid.uuidString)-water-frequency"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
