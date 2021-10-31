import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CLLocationManagerDelegate {
  var window: UIWindow?
  private let locationManager = CLLocationManager()
  private let storyboard = UIStoryboard(name: "Main", bundle: nil)
  private let userCacheData = UserCacheData.shared
  private let firstOpenTime = Int(Date().timeIntervalSince1970)

  private var rootVC: UIViewController?

  private weak var userLocationDelegate: UserLocationDelegate?

  static var timeInApp: Int = 0
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window?.windowScene = windowScene
    getLocation()
    if UserDefaults.standard.bool(forKey: UserDefaultKeys.notFirstStart.rawValue) {
      rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
      self.window?.rootViewController = rootVC
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

  func sceneDidDisconnect(_ scene: UIScene) {
    let userDefaultDate = UserDefaults.standard.integer(forKey: UserDefaultKeys.firstOpenTime.rawValue)
    let saveDate = userDefaultDate + SceneDelegate.timeInApp
    UserDefaults.standard.set(saveDate, forKey: UserDefaultKeys.firstOpenTime.rawValue)
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let coordinate = manager.location?.coordinate
    userLocationDelegate?.saveLocation(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0)
    locationManager.stopUpdatingLocation()
  }
  private func getLocation() {
    userLocationDelegate = userCacheData
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
  }
}
