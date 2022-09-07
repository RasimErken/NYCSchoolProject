//
//  Notification.swift
//  MVVM
//
//  Created by rasim rifat erken on 30.08.2022.
//

import Foundation
import NotificationCenter

class NotificationClass {
    static let instance = NotificationClass()
    
    func notification(body:String , notification:String) {
        
        let center = UNUserNotificationCenter.current()
                
        center.requestAuthorization(options: [.alert , .sound , .badge]) { success, _ in
            guard success else{ return }
            print("Success App")
        }
        
        let content = UNMutableNotificationContent()
        content.title = notification
        content.body = body
        content.sound = .default
        content.badge = 1
    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
                
        let uuidString = UUID().uuidString
                
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                
        UNUserNotificationCenter.current().add(request)
    }
    
}
