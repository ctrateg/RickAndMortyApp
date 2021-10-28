import Foundation

struct EpisodesDTO: Codable {
  let info: InfoDTO
  let results: [EpisodesResultDTO]
}
