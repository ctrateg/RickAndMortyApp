struct CharacterDTO: Codable {
  let info: InfoDTO
  var results: [CharacterResultsDTO]
}
