import Foundation

struct InfoDTO: Codable {
  let count: Int
  let pages: Int
  let next: String?
  let prev: String?
}
