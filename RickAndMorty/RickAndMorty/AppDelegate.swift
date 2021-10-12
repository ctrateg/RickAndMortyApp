import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "RickAndMorty")
      container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()
    func saveContext () {
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
