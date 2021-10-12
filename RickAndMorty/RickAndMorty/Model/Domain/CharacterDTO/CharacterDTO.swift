import Foundation

struct CharacterDTO: Codable {
  let info: InfoDTO
  let results: [CharacterResultDTO]
}
