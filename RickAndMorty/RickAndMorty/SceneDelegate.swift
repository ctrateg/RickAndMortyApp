import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var rootVC: UIViewController?
  private let storyboard = UIStoryboard(name: "Main", bundle: nil)
  private lazy var informatorObject = {
    return Informator()
  }
  private lazy var userCacheData = {
    return UserCacheData()
  }
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene
    if UserDefaults.standard.bool(forKey: "not_first_start") {
      rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
      self.window?.rootViewController = rootVC
    } else {
      UserDefaults.standard.set(true, forKey: "not_first_start")
      rootVC = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController
      self.window?.rootViewController = rootVC
    }
    informatorObject().takeInCache(tag: "character", page: "1")
    informatorObject().takeInCache(tag: "episodes", page: "1")
    informatorObject().takeInCache(tag: "location", page: "1")
  }
  func sceneDidDisconnect(_ scene: UIScene) {
    userCacheData().clearData()
  }
}
