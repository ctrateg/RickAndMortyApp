import CoreData
import UIKit

class LocalDataManager: LocalCacheSaveProtocol {
  static var shared: LocalDataManager = {
    let instance = LocalDataManager()
    return instance
  }()
  static var favoriteCharacters: [CharacterCache] = []
  static var favoriteLocation: [LocationCache] = []
  static var favoriteEpisodes: [EpisodesCache] = []
  private init() {}
  weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

  func saveData(data: CharacterResultsDTO) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
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
    entity.url = data.url

    do {
    try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }

    DispatchQueue.global(qos: .background).async {
      self.loadItems { responce in
        LocalDataManager.favoriteCharacters = responce
      }
    }
  }

  func saveData(data: LocationResultsDTO) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let entity = LocationCache(context: context)
    entity.id = Int64(data.id)
    entity.name = data.name
    entity.type = data.type
    entity.date = data.created
    entity.dimension = data.dimension
    entity.residents = data.residents
    entity.created = data.created
    entity.url = data.url
    do {
    try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
    DispatchQueue.global(qos: .background).async {
      self.loadItems { responce in
        LocalDataManager.favoriteLocation = responce
      }
    }
  }
  func saveData(data: EpisodesResultsDTO) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let entity = EpisodesCache(context: context)
    entity.id = Int64(data.id)
    entity.name = data.name
    entity.created = data.created
    entity.episodes = data.episode
    entity.airDate = data.airDate
    entity.characters = data.characters
    entity.url = data.url
    do {
      try context.save()
    } catch let error as NSError {
      print("Ошибка при сохранении: \(error), \(error.userInfo)")
    }
    DispatchQueue.global(qos: .background).async {
      self.loadItems { responce in
        LocalDataManager.favoriteEpisodes = responce
      }
    }
  }
}

extension LocalDataManager: LocalCacheLoadProtocol {
  func loadItems(completion: @escaping ([CharacterCache]) -> Void) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let request = NSFetchRequest<CharacterCache>(entityName: "CharacterCache")
    do {
      completion(try context.fetch(request))
    } catch let error as NSError {
      print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
    }
  }

  func loadItems(completion: @escaping ([EpisodesCache]) -> Void) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let request = NSFetchRequest<EpisodesCache>(entityName: "EpisodesCache")
    do {
      completion( try context.fetch(request))
    } catch let error as NSError {
      print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
    }
  }

  func loadItems(completion: @escaping ([LocationCache]) -> Void) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    let request = NSFetchRequest<LocationCache>(entityName: "LocationCache")
    do {
      completion(try context.fetch(request))
    } catch let error as NSError {
      print("Ошибка при загрузке данных: \(error), \(error.userInfo)")
    }
  }
}

extension LocalDataManager: LocalCacheDeleteProtocol {
  func deleteItem(deleteData: NSManagedObject) {
    guard let context = appDelegate?.persistentContainer.viewContext else { return }
    context.delete(deleteData)
    do {
      try context.save()
    } catch let error as NSError {
      print("Ошибка при удалении: \(error), \(error.userInfo)")
    }
    switch deleteData {
    case is CharacterCache:
      self.loadItems { responce in
        LocalDataManager.favoriteCharacters = responce
      }
    case is LocationCache:
      self.loadItems { responce in
        LocalDataManager.favoriteLocation = responce
      }
    case is EpisodesCache:
      self.loadItems { responce in
        LocalDataManager.favoriteEpisodes = responce
      }
    default:
      return
    }
  }
}
