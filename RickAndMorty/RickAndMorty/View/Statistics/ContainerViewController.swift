import UIKit

class ContainerViewController: UIViewController {
  @IBOutlet weak var segmenController: UISegmentedControl!
  @IBOutlet weak var presentView: UIView!
  @IBOutlet weak var subNavigationBarOutlet: UINavigationItem!
  private var tag = 0

  private let appearance = UINavigationBarAppearance()
  private let storyboardName = UIStoryboard(name: "StatisticsUI", bundle: nil)
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presentViewConfig(tag: 0)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    configurationNavgiationC()
    segmenController.tintColor = .white
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
      presentView.addSubview(statisticVC.view)
    default:
      guard let statisticVC = storyboardName
        .instantiateViewController(withIdentifier: "StatisticsViewController") as? StatisticsViewController else {
          return
        }
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
    self.navigationItem.title = "Statistics"
    subNavigationBarOutlet.standardAppearance = appearance
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
}
