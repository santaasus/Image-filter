//
//  NotificationsEvents.swift
//  ImageFilter
//
//  Created by Владимир on 11.08.17.
//  Copyright © 2017 com.favorite. All rights reserved.
//

import Foundation

enum Notification : String {
   case saveImage = "save_in_gellary"
}

class NotificationManager {
    
   static func addObserver(object: AnyObject, selector: Selector, notification: Notification) {
          NotificationCenter.default.addObserver(object, selector: selector, name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
    }
    
    static func removeObserver(object: AnyObject) {
        NotificationCenter.default.removeObserver(object)
    }
    
    static func postNotification(_ notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
    }

}
