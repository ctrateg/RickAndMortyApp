import Foundation

protocol InformatorDelegate: AnyObject {
  func takeInCache(tag: TagName, page: String)
}
