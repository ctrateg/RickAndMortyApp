protocol TitleNavigationDelegate: AnyObject {
  func changeTitle(_ titleName: String)
}
protocol RequestServiceDelegate: AnyObject {
  func characterRequestAPI(page: String, completion: @escaping (CharacterDTO) -> Void)
  func locationRequestAPI(page: String, completion: @escaping (LocationDTO) -> Void)
  func episodesRequestAPI(page: String, completion: @escaping (EpisodesDTO) -> Void)
}
// TODO: Fix repeat shit
protocol UserCacheRequestDelegate: AnyObject {
  func saveData(data: CharacterDTO, index: Int)
  func saveData(data: LocationDTO, index: Int)
  func saveData(data: EpisodesDTO, index: Int)
}
protocol UserCashLoadDelegate: AnyObject {
  func loadItems(completion: @escaping ([CharacterCache]) -> Void)
  func loadItems(completion: @escaping ([EpisodesCache]) -> Void)
  func loadItems(completion: @escaping ([LocationCache]) -> Void)
}
protocol InformatorDelegate: AnyObject {
  func takeInCache(tag: String, page: String)
}
