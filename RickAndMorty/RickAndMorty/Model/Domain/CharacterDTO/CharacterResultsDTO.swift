struct CharacterResultsDTO: Codable {
  let id: Int
  let name: String
  let status: String?
  let species: String?
  let type: String?
  let gender: String?
  let origin: OriginDTO?
  let location: LocationArrayDTO?
  let image: String
  let episode: [String]?
  let url: String
  let created: String
}
