import Foundation
import CoreData

protocol UserCacheSaveProtocol: AnyObject {
  func saveData(data: CharacterResultDTO)
  func saveData(data: LocationResultDTO)
  func saveData(data: EpisodesResultDTO)
}

protocol UserCacheLoadProtocol: AnyObject {
  func loadItems(completion: @escaping ([CharacterCache]) -> Void)
  func loadItems(completion: @escaping ([EpisodesCache]) -> Void)
  func loadItems(completion: @escaping ([LocationCache]) -> Void)
}

protocol UserLocationProtocol: AnyObject {
  func saveLocation(latitude: Double, longitude: Double)
  func loadLocations(completion: @escaping ([UserLocation]) -> Void)
}

protocol UserCacheDeleteProtocol: AnyObject {
  func deleteItem(deletData: NSManagedObject)
}
