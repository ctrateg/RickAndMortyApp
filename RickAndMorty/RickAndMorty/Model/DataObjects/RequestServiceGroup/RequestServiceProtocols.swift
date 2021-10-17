protocol RequestServiceDelegate: AnyObject {
  func characterRequestAPI(page: String, completion: @escaping (CharacterDTO) -> Void)
  func locationRequestAPI(page: String, completion: @escaping (LocationDTO) -> Void)
  func episodesRequestAPI(page: String, completion: @escaping (EpisodesDTO) -> Void)
}
protocol RequestSerivceSearchDelegate: AnyObject {
  func characterSearch(tag: String, completion: @escaping (CharacterDTO) -> Void)
}
