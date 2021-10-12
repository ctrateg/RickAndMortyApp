import UIKit

class ContainerViewController: UIViewController, UITabBarControllerDelegate {
  private let appearance = UINavigationBarAppearance()
  private var returnVC = UITableViewController()
  private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.delegate = self
    configureMainInfoTableView(index: tabBarController?.selectedIndex ?? 0)
    configurationNavgiationC()
  }
  /// Настройки основного табличного представления
  private func configureMainInfoTableView(index: Int) {
    switch index {
    case 0:
      guard let characterVC = mainStoryboard.instantiateViewController(
        withIdentifier: "CharactersTableView") as? CharactersTableView else { return }
      returnVC = characterVC
      self.navigationItem.title = "Character"
    case 1:
      guard let locationVC = mainStoryboard.instantiateViewController(
        withIdentifier: "LocationsTableView") as? LocationTableViewController else { return }
      returnVC = locationVC
      self.navigationItem.title = "Location"
    case 2:
      guard let favoritecVC = mainStoryboard.instantiateViewController(
        withIdentifier: "CharactersTableView") as? CharactersTableView else { return }
      returnVC = favoritecVC
      self.navigationItem.title = "Favorites"
    case 3:
      guard let statisticsVC = mainStoryboard.instantiateViewController(
        withIdentifier: "CharactersTableView") as? CharactersTableView else { return }
      returnVC = statisticsVC
      self.navigationItem.title = "Statistics"
    default:
      guard let episodesVC = mainStoryboard.instantiateViewController(
        withIdentifier: "EpisodesTableView") as? EpisodesTableViewController else { return }
      returnVC = episodesVC
      self.navigationItem.title = "Episodes"
    }
    self.view.addSubview(returnVC.view)
    addChild(returnVC)
  }
  private func configurationNavgiationC() {
    let navigationBar = self.navigationController?.navigationBar
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
}
