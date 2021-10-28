import Foundation

// TODO: Fix repeat shit
protocol UserCacheSaveDelegate: AnyObject {
  func saveData(data: CharacterDTO, index: Int)
  func saveData(data: LocationDTO, index: Int)
  func saveData(data: EpisodesDTO, index: Int)
}
protocol UserCacheLoadDelegate: AnyObject {
  func loadItems(completion: @escaping ([CharacterCache]) -> Void)
  func loadItems(completion: @escaping ([EpisodesCache]) -> Void)
  func loadItems(completion: @escaping ([LocationCache]) -> Void)
}
protocol UserCacheClearDelegate: AnyObject {
  func clearData()
}

protocol UserCacheFavoriteDelage: AnyObject {
  func saveInFavorites(data: AnyObject)
}
protocol GetImageDelegate: AnyObject {
  func getImage(urlInput: String) -> Data?
}

protocol UserLocationDelegate: AnyObject {
  func saveLocation(latitude: Double, longitude: Double)
  func loadItems(completion: @escaping ([UserLocation]) -> Void)
}
