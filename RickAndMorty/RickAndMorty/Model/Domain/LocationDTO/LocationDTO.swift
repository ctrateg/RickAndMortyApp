import Foundation

struct LocationDTO: Codable {
  let info: InfoDTO
  let results: [LocationResultDTO]
}
