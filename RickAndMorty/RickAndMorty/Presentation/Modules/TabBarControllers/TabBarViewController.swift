import UIKit

class TabBarViewController: UITabBarController, StoryboardCreatable {
  var presenter: TabBarViewOutput?
  private let middleButtonDiameter: CGFloat = 58
  private lazy var middleButton: UIButton = {
    let middleButton = UIButton(type: .custom)
    middleButton.layer.cornerRadius = middleButtonDiameter / 2
    middleButton.backgroundColor = CustomColors.mainColor
    middleButton.translatesAutoresizingMaskIntoConstraints = false
    middleButton.setImage(ImagesTabBar.favorites, for: .normal)
    middleButton.adjustsImageWhenHighlighted = false
    middleButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
    middleButton.addTarget(self, action: #selector(didPressMiddleButton), for: .touchUpInside)
    return middleButton
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = TabBarPresenter(view: self)
    viewControllersConfiguration()
  }

  private func viewControllersConfiguration() {
    viewControllers = presenter?.setViewcontrollers()
    makeUI()
    self.tabBar.unselectedItemTintColor = .white
    tabBar.items?[2].isEnabled = false
  }

  @objc private func didPressMiddleButton() {
    selectedIndex = 2
    middleButton.setImage(ImagesTabBar.favorites.withTintColor(.yellow), for: .normal)
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
    middleButton.setImage(ImagesTabBar.favorites, for: .normal)
  }
}
