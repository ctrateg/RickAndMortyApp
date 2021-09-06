import Foundation
import Locksmith

class Utility {
}

struct KeyChainAccount: CreateableSecureStorable, GenericPasswordSecureStorable {
  let username: String
  let password: String
  var data: [String: Any] {
    return ["password": password]
  }
  var service: String = "KeyChainAccount"
  var account: String {
    return username
  }
}
