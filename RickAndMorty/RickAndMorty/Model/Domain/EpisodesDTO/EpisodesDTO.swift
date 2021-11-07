struct EpisodesDTO: Codable {
  let info: InfoDTO
  let results: [EpisodesResultsDTO]
}
