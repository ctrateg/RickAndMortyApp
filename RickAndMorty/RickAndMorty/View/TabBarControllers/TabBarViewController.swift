import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
  private let middleButtonDiameter: CGFloat = 58

  private lazy var middleButton: UIButton = {
    let middleButton = UIButton(type: .custom)
    middleButton.layer.cornerRadius = middleButtonDiameter / 2
    middleButton.backgroundColor = UIColor(named: "MainColor")
    middleButton.translatesAutoresizingMaskIntoConstraints = false
    middleButton.setImage(UIImage(named: "FavoriteImage"), for: .normal)
    middleButton.adjustsImageWhenHighlighted = false
    middleButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    middleButton.addTarget(self, action: #selector(didPressMiddleButton), for: .touchUpInside)
    return middleButton
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllersConfiguration()
    delegate = self
  }

  private func viewControllersConfiguration() {
    let charactersVC = UIStoryboard(name: "CharactersUI", bundle: nil)
      .instantiateViewController(withIdentifier: "CharacterNavigationController")
    charactersVC.tabBarItem.title = "characters"
    charactersVC.tabBarItem.image = UIImage(named: "CharacterImage")

    let locationsVC = UIStoryboard(name: "LocationUI", bundle: nil)
      .instantiateViewController(withIdentifier: "LocationNavigationController")
    locationsVC.tabBarItem.title = "locations"
    locationsVC.tabBarItem.image = UIImage(named: "LocationImage")
    locationsVC.tabBarItem.badgeColor = .white

    let favoritesVC = UIStoryboard(name: "FavoriteUI", bundle: nil)
      .instantiateViewController(withIdentifier: "FavoriteNavigationController")
    favoritesVC.tabBarItem.title = ""
    let statisticsVC = UIStoryboard(name: "StatisticsUI", bundle: nil)
      .instantiateViewController(withIdentifier: "StatisticsNavigationController")
    statisticsVC.tabBarItem.title = "statistics"
    statisticsVC.tabBarItem.image = UIImage(named: "StatisticImage")

    let episodesVC = UIStoryboard(name: "EpisodesUI", bundle: nil)
      .instantiateViewController(withIdentifier: "EpisodesNavigationController")
    episodesVC.tabBarItem.title = "episodes"
    episodesVC.tabBarItem.image = UIImage(named: "EpisodeImage")

    viewControllers = [charactersVC, locationsVC, favoritesVC, statisticsVC, episodesVC]
    makeUI()
    self.tabBar.unselectedItemTintColor = .white
    tabBar.items?[2].isEnabled = false
  }

  @objc private func didPressMiddleButton() {
    selectedIndex = 2
    middleButton.setImage(UIImage(named: "FavoriteImage")?.withTintColor(.yellow), for: .normal)
  }

  private func makeUI() {
    tabBar.addSubview(middleButton)
    NSLayoutConstraint.activate([
      middleButton.heightAnchor.constraint(equalToConstant: middleButtonDiameter),
      middleButton.widthAnchor.constraint(equalToConstant: middleButtonDiameter),
      middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
      middleButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -35)
    ])
  }
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    middleButton.setImage(UIImage(named: "FavoriteImage"), for: .normal)
  }
}
