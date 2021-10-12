import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
  let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
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
    let charactersVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController")
    charactersVC.tabBarItem.title = "characters"
    charactersVC.tabBarItem.image = UIImage(named: "CharacterImage")

    let locationsVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController")
    locationsVC.tabBarItem.title = "locations"
    locationsVC.tabBarItem.image = UIImage(named: "LocationImage")
    locationsVC.tabBarItem.badgeColor = .white

    let favoritesVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController")
    favoritesVC.tabBarItem.title = ""

    let statisticsVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController")
    statisticsVC.tabBarItem.title = "statistics"
    statisticsVC.tabBarItem.image = UIImage(named: "StatisticImage")

    let episodesVC = mainStoryboard.instantiateViewController(withIdentifier: "NavigationController")
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
