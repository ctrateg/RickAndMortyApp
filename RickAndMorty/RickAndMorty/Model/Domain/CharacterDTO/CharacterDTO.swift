import Foundation

struct CharacterDTO: Codable {
  let info: InfoDTO
  var results: [CharacterResultDTO]
}
