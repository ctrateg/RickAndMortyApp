import UIKit

class ContainerViewController: UIViewController, MainInfoTableViewDelegate {
  var controller: UITableViewController!
  var menuBurger: UIViewController!
  var isMove = false
  override func viewDidLoad() {
    super.viewDidLoad()
    configureMainInfoTableView()
    }
  func configureMainInfoTableView() {
    let mainInfoTV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainInfoTableView") as? MainInfoTableView
    mainInfoTV?.delegate = self
    controller = mainInfoTV
    view.addSubview(controller.view)
    addChild(controller)
  }
  func configureBurgerMenu() {
    if menuBurger == nil {
      menuBurger = MenuViewController()
      view.insertSubview(menuBurger.view, at: 0)
      addChild(menuBurger)
    }
  }

  func showBurgerMenuViewController(_ shouldMove: Bool) {
    if shouldMove {
      UIView.animate( withDuration: 0.5,
                      delay: 0,
                      usingSpringWithDamping: 0.8,
                      initialSpringVelocity: 0,
                      options: .curveEaseInOut,
                      animations: {
                      self.controller.view.frame.origin.x = self.controller.view.frame.width - 140
                     }) { (fininshed) in
      }
    } else {
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.8,
                     initialSpringVelocity: 0,
                     options: .curveEaseInOut,
                     animations: {
                      self.controller.view.frame.origin.x = 0
                     }) { (fininshed) in
      }

    }
  }
  // MARK: MainInfoTableViewDelegate
  func toggleMenu() {
    configureBurgerMenu()
    isMove = !isMove
    showBurgerMenuViewController(isMove)
  }
}
