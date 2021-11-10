import UIKit

extension UIViewController {
  func configurationNavgiationC(title: String) {
    let appearance = UINavigationBarAppearance()
    let navigationBar = self.navigationController?.navigationBar
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    appearance.shadowColor = .clear
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    self.navigationItem.title = title
    navigationItem.backButtonTitle = "Back"
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
}
