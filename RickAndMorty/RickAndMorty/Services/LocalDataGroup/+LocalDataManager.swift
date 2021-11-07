import CoreData
import UIKit

extension LocalDataManager: LocationProtocol {
  func saveLocation(latitude: Double, longitude: Double) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let entity = UserLocation(context: context)
    entity.latitude = latitude
    entity.longitude = longitude
    do {
    try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
  }
  func loadLocations(completion: @escaping ([UserLocation]) -> Void) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let request = NSFetchRequest<UserLocation>(entityName: "UserLocation")
    do {
      completion(try context.fetch(request))
    } catch let error as NSError {
      print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
    }
  }
}

extension LocalDataManager: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
