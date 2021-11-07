import UIKit

class ContainerViewController: UIViewController {
  @IBOutlet weak var segmenController: UISegmentedControl!
  @IBOutlet weak var presentView: UIView!
  @IBOutlet weak var subNavigationBarOutlet: UINavigationItem!

  private weak var userLocationDelegate: LocationProtocol?
  private var userLocationCache: [UserLocation]?
  private var tag = 0

  private let appearance = UINavigationBarAppearance()
  private let storyboardName = UIStoryboard(name: "StatisticsUI", bundle: nil)
  override func viewDidLoad() {
    super.viewDidLoad()
    userLocationDelegate = LocalDataManager.shared
    takeLocation()
    configurationNavgiationC()
    segmenController.tintColor = .white
    presentViewConfig(tag: 0)
  }

  @IBAction func segmentControllerAction(_ sender: UISegmentedControl) {
    presentViewConfig(tag: segmenController.selectedSegmentIndex)
  }

  private func presentViewConfig(tag: Int) {
    switch tag {
    case 1:
      guard let statisticVC = storyboardName
        .instantiateViewController(withIdentifier: "GoogleMapViewController") as? GoogleMapViewController else {
          return
        }
      statisticVC.userLocationCache = userLocationCache
      self.navigationItem.title = "Map"
      presentView.addSubview(statisticVC.view)
    default:
      guard let statisticVC = storyboardName
        .instantiateViewController(withIdentifier: "StatisticsViewController") as? StatisticsViewController else {
          return
        }
      self.navigationItem.title = "In App Time"
      presentView.addSubview(statisticVC.view)
    }
  }
  private func configurationNavgiationC() {
    let navigationBar = self.navigationController?.navigationBar
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    appearance.shadowColor = .clear
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    self.navigationItem.title = "In App Time"
    subNavigationBarOutlet.standardAppearance = appearance
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
  private func takeLocation() {
    self.userLocationDelegate?.loadLocations { responce in
      self.userLocationCache = responce
    }
  }
}
