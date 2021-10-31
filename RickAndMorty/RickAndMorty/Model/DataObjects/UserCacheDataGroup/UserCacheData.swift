import CoreData
import UIKit

class UserCacheData: UserCacheSaveDelegate,
  UserCacheLoadDelegate,
  GetImageDelegate {
  static var shared: UserCacheData = {
    let instance = UserCacheData()
    return instance
  }()
  private init() {}

  func saveData(data: CharacterDTO, index: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let entity = CharacterCache(context: context)
    entity.id = Int64(data.results[index].id)
    entity.name = data.results[index].name
    entity.gender = data.results[index].gender
    entity.created = data.results[index].created
    entity.image = getImage(urlInput: data.results[index].image)
    entity.location = data.results[index].location?.name
    entity.locationURL = data.results[index].location?.url
    entity.status = data.results[index].status
    entity.type = data.results[index].type
    entity.episodes = data.results[index].episode
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
  func getImage(urlInput: String) -> Data? {
    guard let url = URL(string: urlInput) else { return nil }
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch _ as NSError {
      print("Save image error")
    }
    return nil
  }
}
