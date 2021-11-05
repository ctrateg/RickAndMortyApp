protocol RequestServiceProtocol: AnyObject {
  func characterRequestAPI(page: String, completion: @escaping (CharacterDTO) -> Void)
  func locationRequestAPI(page: String, completion: @escaping (LocationDTO) -> Void)
  func episodesRequestAPI(page: String, completion: @escaping (EpisodesDTO) -> Void)
}

protocol RequestSerivceSearchProtocol: AnyObject {
  func characterSearch(tag: String, completion: @escaping (CharacterDTO) -> Void)
}

protocol SingleRequestProtocol: AnyObject {
  func requestForCharacter(urlArray: [String], completion: @escaping ([CharacterResultDTO]) -> Void)
  func requestForEpisodes(urlArray: [String], completion: @escaping ([EpisodesResultDTO]) -> Void)
  func requestForLocation(urlArray: [String], completion: @escaping ([LocationResultDTO]) -> Void)
}
