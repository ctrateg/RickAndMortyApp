import CoreData
import UIKit

class UserCacheData: UserCacheSaveDelegate,
  UserCacheLoadDelegate {
  static var shared: UserCacheData = {
    let instance = UserCacheData()
    return instance
  }()
  private init() {}

  func saveData(data: CharacterResultDTO) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let entity = CharacterCache(context: context)
    entity.id = Int64(data.id)
    entity.name = data.name
    entity.gender = data.gender
    entity.created = data.created
    entity.image = data.image
    entity.location = data.location?.name
    entity.locationURL = data.location?.url
    entity.status = data.status
    entity.type = data.type
    entity.episodes = data.episode
    do {
    try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
  }
  func saveData(data: LocationDTO, index: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let entity = LocationCache(context: context)
    entity.id = Int64(data.results[index].id)
    entity.name = data.results[index].name
    entity.type = data.results[index].type
    entity.date = data.results[index].created
    entity.dimension = data.results[index].dimension
    entity.residents = data.results[index].residents
    entity.created = data.results[index].created
    do {
    try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
  }

  func saveData(data: EpisodesDTO, index: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let entity = EpisodesCache(context: context)
    entity.id = Int64(data.results[index].id)
    entity.name = data.results[index].name
    entity.created = data.results[index].created
    entity.episodes = data.results[index].episode
    entity.airDate = data.results[index].airDate
    entity.characters = data.results[index].characters
    do {
      try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
  }
  func loadItems(completion: @escaping ([CharacterCache]) -> Void) {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<CharacterCache>(entityName: "CharacterCache")
      do {
        completion(try context.fetch(request))
      } catch let error as NSError {
        print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
      }
    }
  }

  func loadItems(completion: @escaping ([EpisodesCache]) -> Void) {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<EpisodesCache>(entityName: "EpisodesCache")
      do {
        completion( try context.fetch(request))
      } catch let error as NSError {
        print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
      }
    }
  }

  func loadItems(completion: @escaping ([LocationCache]) -> Void) {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<LocationCache>(entityName: "LocationCache")
      do {
        completion(try context.fetch(request))
      } catch let error as NSError {
        print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
      }
    }
  }
//  func deletItem() {
//    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//    let context = appDelegate.persistentContainer.viewContext
//    let entity = CharacterCache(context: context)
//    context.delete(entity)
//
//    do {
//      try context.save()
//    } catch let error as NSError {
//      print("Ошибка при сохранении: \(error), \(error.userInfo)")
//    }
//  }
}
