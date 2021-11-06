import UIKit
import CoreData
import GoogleMaps
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDzUcB8cWd1LG1cwT9BaUk4nvOukx-kAZc")
    NotificationCenter.shared.author()
    return true
  }
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "RickAndMorty")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        context.rollback()
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
