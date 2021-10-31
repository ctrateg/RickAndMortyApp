protocol RequestServiceDelegate: AnyObject {
  func characterRequestAPI(page: String, completion: @escaping ([CharacterResultDTO]) -> Void)
  func locationRequestAPI(page: String, completion: @escaping ([LocationResultDTO]) -> Void)
  func episodesRequestAPI(page: String, completion: @escaping ([EpisodesResultDTO]) -> Void)
}
protocol RequestSerivceSearchDelegate: AnyObject {
  func characterSearch(tag: String, completion: @escaping (CharacterDTO) -> Void)
}

protocol SingleRequestDelegate: AnyObject {
  func requestForCharacter(urlArray: [String], completion: @escaping ([CharacterResultDTO]) -> Void)
  func requestForEpisodes(urlArray: [String], completion: @escaping ([EpisodesResultDTO]) -> Void)
  func requestForLocation(urlArray: [String], completion: @escaping ([LocationResultDTO]) -> Void)
}
