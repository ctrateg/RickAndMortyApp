import Foundation

protocol InformatorDelegate: AnyObject {
  func takeInCache(tag: String, page: String)
}
