import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private weak var informatorDelegate: InformatorDelegate?
  private let userCacheData = UserCacheData.shared
  private var rootVC: UIViewController?
  private let storyboard = UIStoryboard(name: "Main", bundle: nil)
  private weak var userCacheClearDelegate: UserCacheClearDelegate?
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
    self.informatorDelegate = Informator.shared
    DispatchQueue.global(qos: .background).async {
      self.informatorDelegate?.takeInCache(tag: "character", page: "1")
      self.informatorDelegate?.takeInCache(tag: "episodes", page: "1")
      self.informatorDelegate?.takeInCache(tag: "location", page: "1")
    }
  }
  func sceneDidDisconnect(_ scene: UIScene) {
    userCacheData.clearData()
  }
}
