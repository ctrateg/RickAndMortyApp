import UserNotifications
import UIKit

class NotificationCenter {
  static var shared: NotificationCenter = {
    let instance = NotificationCenter()
    return instance
  }()
  private init() {}

  private let notificationCenter = UNUserNotificationCenter.current()

  func author() {
    notificationCenter.requestAuthorization(options: [.alert, . sound, .badge]) { granted, _ in
      guard granted else { return }
      self.notificationCenter.getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else { return }
      }
    }
  }
  func sendNotifications(interval: TimeInterval) {
    let content = UNMutableNotificationContent()
    content.title = "Please come back"
    content.body = "It is for 5 min only!"
    content.sound = UNNotificationSound.default
    content.badge = 1
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
    let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
    notificationCenter.add(request) { error in
      print(error?.localizedDescription ?? "NotificationConnected")
    }
  }
}

extension NotificationCenter: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
