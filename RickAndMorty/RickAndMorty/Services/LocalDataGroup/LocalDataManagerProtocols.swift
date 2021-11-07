import CoreData

protocol LocalCacheSaveProtocol: AnyObject {
  func saveData(data: CharacterResultsDTO)
  func saveData(data: LocationResultsDTO)
  func saveData(data: EpisodesResultsDTO)
}

protocol LocalCacheLoadProtocol: AnyObject {
  func loadItems(completion: @escaping ([CharacterCache]) -> Void)
  func loadItems(completion: @escaping ([EpisodesCache]) -> Void)
  func loadItems(completion: @escaping ([LocationCache]) -> Void)
}

protocol LocationProtocol: AnyObject {
  func saveLocation(latitude: Double, longitude: Double)
  func loadLocations(completion: @escaping ([UserLocation]) -> Void)
}

protocol LocalCacheDeleteProtocol: AnyObject {
  func deleteItem(deleteData: NSManagedObject)
}
