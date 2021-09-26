import UIKit

class ContainerViewController: UIViewController, MenuDelegate, TitleNavigationDelegate {
  private var controller = UIViewController()
  private var menuBurger: UIViewController?
  private var mainInfoTV = UITableViewController()
  private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
  private var isMove = false
  private var tapGesture = UITapGestureRecognizer()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureMainInfoTableView()
    gestureConfiguration()
  }
  /// Настройки перехода по нажатию вне поля
  private func gestureConfiguration() {
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    tapGesture.numberOfTouchesRequired = 1
    tapGesture.numberOfTapsRequired = 1
    self.controller.view.isUserInteractionEnabled = true
  }
  @objc func viewTapped() {
    toggleMenu()
  }
  /// Настройки основного табличного представления
  private func configureMainInfoTableView() {
    guard let mainTVC = mainStoryboard.instantiateViewController(
      withIdentifier: "MainInfoTableView") as? MainInfoTableView else { return }
    let container = UINavigationController(rootViewController: mainTVC)
    mainTVC.delegate = self
    mainInfoTV = mainTVC
    controller = container
    self.view.addSubview(controller.view)
    addChild(controller)
  }
  /// Настройки бокового меню
  private func configureBurgerMenu() {
    if menuBurger == nil {
      guard let mainTVC = mainStoryboard.instantiateViewController(
        withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
      menuBurger = mainTVC
      mainTVC.titleDelegate = self
      mainTVC.delegate = self
      self.menuBurger?.view.frame.origin.x = -(self.menuBurger?.view.frame.width ?? 0)
      self.view.insertSubview(menuBurger?.view ?? view, at: 1)
      addChild(menuBurger ?? self)
      menuBurger?.didMove(toParent: self)
    }
  }
  /// Отвечает за анимацию бокового меню
  /// - Parameter shouldMove: Bool
  private func showBurgerMenuViewController(_ shouldMove: Bool) {
    if shouldMove {
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: .curveEaseInOut) {
        self.menuBurger?.view.frame.origin.x = 0
      }
    } else {
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: .curveEaseInOut) {
        self.menuBurger?.view.frame.origin.x = -(self.menuBurger?.view.frame.width ?? 0)
      }
    }
  }
  // MARK: MenuDelegate
  func toggleMenu() {
    isMove.toggle()
    switch isMove {
    case true:
      self.controller.view.addGestureRecognizer(tapGesture)
    case false:
      self.controller.view.removeGestureRecognizer(tapGesture)
    }
    configureBurgerMenu()
    showBurgerMenuViewController(isMove)
  }
  // MARK: TitleNavigationDelegate
  func changeTitle(_ titleName: String) {
    mainInfoTV.navigationItem.title = titleName
  }
}
