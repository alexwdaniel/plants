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
        content.subtitle = "Time to water \(plant.name ?? "a plant.")"
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let frequency = TimeInterval(plant.waterFrequency) * 24 * 60 * 60
        print("set recurring notification for every \(frequency) seconds")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: frequency, repeats: true)

        // choose a random identifier
        let id = "\(uuid.uuidString)-water-frequency"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
