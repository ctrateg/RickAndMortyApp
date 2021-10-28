import Alamofire
import Foundation

class RequestServiceAPI: RequestServiceDelegate, RequestSerivceSearchDelegate, SingleRequestDelegate {
  static var shared: RequestServiceAPI = {
    let instance = RequestServiceAPI()
    return instance
  }()
  private init() {}
  private let jsonDecoder = JSONDecoder()
  private let rickAndMortyAPI = "https://rickandmortyapi.com/api"
  func characterRequestAPI(page: String = "1", completion: @escaping (CharacterDTO) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let url = URL(string: "\(rickAndMortyAPI)/character?page=\(page)") else { return }
    AF.request(url)
      .responseJSON { responce in
      guard let data = responce.data else { return }
        do {
          let returnData = try self.jsonDecoder.decode(CharacterDTO.self, from: data)
          completion(returnData)
        } catch let error as NSError {
          print("\(error), \(error.userInfo)")
        }
      }
    .resume()
  }
  func locationRequestAPI(page: String = "1", completion: @escaping (LocationDTO) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let url = URL(string: "\(rickAndMortyAPI)/location?page=\(page)") else { return }
    AF.request(url)
      .responseJSON { responce in
      guard let data = responce.data else { return }
        do {
          let returnData = try self.jsonDecoder.decode(LocationDTO.self, from: data)
            completion(returnData)
        } catch let error as NSError {
          print("\(error), \(error.userInfo)")
        }
      }
    .resume()
  }
  func episodesRequestAPI(page: String = "1", completion: @escaping (EpisodesDTO) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let url = URL(string: "\(rickAndMortyAPI)/episode?page=\(page)") else { return }
    AF.request(url)
      .responseJSON { responce in
      guard let data = responce.data else { return }
        do {
          let returnData = try self.jsonDecoder.decode(EpisodesDTO.self, from: data)
            completion(returnData)
        } catch let error as NSError {
          print("\(error), \(error.userInfo)")
        }
      }
    .resume()
  }
  func characterSearch(tag: String, completion: @escaping (CharacterDTO) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let url = URL(string: "https://rickandmortyapi.com/api/character?name=\(tag)") else { return }
    AF.request(url)
      .responseJSON { responce in
      guard let data = responce.data else { return }
        do {
          let returnData = try self.jsonDecoder.decode(CharacterDTO.self, from: data)
          completion(returnData)
        } catch let error as NSError {
          print("\(error), \(error.userInfo)")
        }
      }
    .resume()
  }
  func requestForLocation(url: String, completion: @escaping (LocationResultDTO) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let url = URL(string: url) else { return }
    AF.request(url)
      .responseJSON { response in
        guard let data = response.data else { return }
        do {
          let returnData = try self.jsonDecoder.decode(LocationResultDTO.self, from: data)
          completion(returnData)
        } catch let error as NSError {
          print("\(error), \(error.userInfo)")
        }
      }
      .resume()
  }
  func requestForCharacter(url: String, completion: @escaping (CharacterResultDTO) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    guard let url = URL(string: url) else { return }
    AF.request(url)
      .responseJSON { response in
        guard let data = response.data else { return }
        do {
          let returnData = try self.jsonDecoder.decode(CharacterResultDTO.self, from: data)
          completion(returnData)
        } catch let error as NSError {
          print("\(error), \(error.userInfo)")
        }
      }
      .resume()
  }
  // toDo: возвращает массив urlArray.count раз
  func requestForEpisodes(urlArray: [String], completion: @escaping ([EpisodesResultDTO]) -> Void) {
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    var returnArray: [EpisodesResultDTO] = []
    urlArray.forEach { url in
      guard let url = URL(string: url) else { return }
      AF.request(url)
        .responseJSON { response in
          guard let data = response.data else { return }
          do {
            let returnData = try self.jsonDecoder.decode(EpisodesResultDTO.self, from: data)
            returnArray.append(returnData)
            completion(returnArray)
          } catch let error as NSError {
            print("\(error), \(error.userInfo)")
          }
        }
        .resume()
    }
  }
}
extension RequestServiceAPI: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    return self
  }
}
