import Foundation

class Informator: InformatorDelegate {
  private var locationData: LocationDTO?
  private var episodesData: EpisodesDTO?
  private var characterData: CharacterDTO?
  private var requestService = RequestServiceAPI()
  private var userCashData = UserCacheData()
  func takeInCache(tag: String, page: String) {
    switch tag {
    case "character":
      requestService.characterRequestAPI(page: page) { searchResponce in
        self.characterData = searchResponce
        for i in 0..<(searchResponce.results.count) {
          self.userCashData.saveData(data: searchResponce, index: i)
        }
      }
    case "location":
      requestService.locationRequestAPI(page: page) { searchResponce in
        self.locationData = searchResponce
        for i in 0..<(self.locationData?.results.count ?? 1) {
          self.userCashData.saveData(data: self.locationData ?? searchResponce, index: i)
        }
      }
    case "episodes":
      requestService.episodesRequestAPI(page: page) { searchResponce in
        self.episodesData = searchResponce
        for i in 0..<(self.episodesData?.results.count ?? 1) {
          self.userCashData.saveData(data: self.episodesData ?? searchResponce, index: i)
        }
      }
    default: break
    }
  }
}
