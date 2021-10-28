import CoreData
import UIKit

extension UserCacheData: NSCopying, UserLocationDelegate {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
  func saveLocation(latitude: Double, longitude: Double) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let entity = UserLocation(context: context)
    entity.latitude = latitude
    entity.longitude = longitude
    do {
    try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
  }
  func loadItems(completion: @escaping ([UserLocation]) -> Void) {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<UserLocation>(entityName: "UserLocation")
      do {
        completion(try context.fetch(request))
      } catch let error as NSError {
        print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
      }
    }
  }
}
