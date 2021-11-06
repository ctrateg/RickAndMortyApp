import UIKit
import CoreLocation
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  static var timeInApp: Int = 0

  var window: UIWindow?

  private let locationManager = CLLocationManager()
  private let storyboard = UIStoryboard(name: "Main", bundle: nil)
  private let userCacheData = LocalDataManager.shared
  private let firstOpenTime = Int(Date().timeIntervalSince1970)

  private var rootVC: UIViewController?
  private weak var userLocationDelegate: UserLocationProtocol?
  private weak var loadDataDelegate: UserCacheLoadProtocol?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    getLocation()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene

    if UserDefaults.standard.bool(forKey: UserDefaultKeys.notFirstStart.rawValue) {
      rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
      self.window?.rootViewController = rootVC
      loadData()
    } else {
      UserDefaults.standard.set(true, forKey: UserDefaultKeys.notFirstStart.rawValue)
      UserDefaults.standard.set(firstOpenTime, forKey: UserDefaultKeys.firstOpenTime.rawValue)
      rootVC = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController
      self.window?.rootViewController = rootVC
    }

    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      SceneDelegate.timeInApp += 1
    }
  }
  func sceneDidEnterBackground(_ scene: UIScene) {
    NotificationCenter.shared.sendNotifications()
  }
  func sceneWillEnterForeground(_ scene: UIScene) {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  func sceneDidDisconnect(_ scene: UIScene) {
    NotificationCenter.shared.sendNotifications()
    let userDefaultDate = UserDefaults.standard.integer(forKey: UserDefaultKeys.firstOpenTime.rawValue)
    let saveDate = userDefaultDate + SceneDelegate.timeInApp
    UserDefaults.standard.set(saveDate, forKey: UserDefaultKeys.firstOpenTime.rawValue)
  }

  private func loadData() {
    loadDataDelegate = LocalDataManager.shared
    DispatchQueue.global(qos: .background).async {
      self.loadDataDelegate?.loadItems { responce in
        LocalDataManager.favoriteCharacters = responce
      }
      self.loadDataDelegate?.loadItems { responce in
        LocalDataManager.favoriteEpisodes = responce
      }
      self.loadDataDelegate?.loadItems { responce in
        LocalDataManager.favoriteLocation = responce
      }
    }
  }
}

extension SceneDelegate: CLLocationManagerDelegate {
  private func getLocation() {
    userLocationDelegate = userCacheData
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let coordinate = manager.location?.coordinate
    userLocationDelegate?.saveLocation(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0)
    locationManager.stopUpdatingLocation()
  }
}
