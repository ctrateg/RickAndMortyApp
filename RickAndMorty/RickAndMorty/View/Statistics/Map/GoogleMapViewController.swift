import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
  var userLocationCache: [UserLocation]?
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    mapConfiguration()
  }
  private func mapConfiguration() {
    let count = (userLocationCache?.count ?? 0) - 1
    print(count)
    let camera = GMSCameraPosition.camera(
      withLatitude: userLocationCache?[count].latitude ?? 0,
      longitude: userLocationCache?[count].longitude ?? 0,
      zoom: 6.0)
    let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
    self.view.addSubview(mapView)
    let marker = GMSMarker()
    for i in 0...count {
      let position = CLLocationCoordinate2D(
        latitude: userLocationCache?[i].latitude ?? 0,
        longitude: userLocationCache?[i].longitude ?? 0)
      marker.position = position
      marker.iconView?.tag = i
      marker.map = mapView
    }
  }
}
