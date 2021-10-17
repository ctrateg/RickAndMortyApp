import Foundation

class Informator: InformatorDelegate {
  private var locationData: LocationDTO?
  private var episodesData: EpisodesDTO?
  private var characterData: CharacterDTO?
  private weak var userCacheSaveDelegate: UserCacheSaveDelegate?
  private weak var userRequestDelegate: RequestServiceDelegate?
  static var shared: Informator = {
    let instance = Informator()
    return instance
  }()
  func takeInCache(tag: String, page: String) {
    switch tag {
    case "character":
      userRequestDelegate?.characterRequestAPI(page: page) { searchResponce in
        self.characterData = searchResponce
        for i in 0..<(searchResponce.results.count) {
          self.userCacheSaveDelegate?.saveData(data: searchResponce, index: i)
        }
      }
    case "location":
      userRequestDelegate?.locationRequestAPI(page: page) { searchResponce in
        self.locationData = searchResponce
        for i in 0..<(self.locationData?.results.count ?? 1) {
          self.userCacheSaveDelegate?.saveData(data: self.locationData ?? searchResponce, index: i)
        }
      }
    case "episodes":
      userRequestDelegate?.episodesRequestAPI(page: page) { searchResponce in
        self.episodesData = searchResponce
        for i in 0..<(self.episodesData?.results.count ?? 1) {
          self.userCacheSaveDelegate?.saveData(data: self.episodesData ?? searchResponce, index: i)
        }
      }
    default: break
    }
  }
  private init() {
    self.userCacheSaveDelegate = UserCacheData.shared
    self.userRequestDelegate = RequestServiceAPI.shared
  }
}
