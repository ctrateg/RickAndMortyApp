import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
  private weak var userLocationDelegate: UserLocationDelegate?
  private var userLocationCache: [UserLocation]?
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    userLocationDelegate = UserCacheData.shared
    userLocationDelegate?.loadItems { responce in
      self.userLocationCache = responce
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    let camera = GMSCameraPosition.camera(withLatitude: userLocationCache?[0].latitude ?? 0, longitude: userLocationCache?[0].longitude ?? 0, zoom: 6.0)
    let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
    self.view.addSubview(mapView)
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: userLocationCache?[0].latitude ?? 0, longitude: userLocationCache?[0].longitude ?? 0)
    marker.map = mapView
  }
}
