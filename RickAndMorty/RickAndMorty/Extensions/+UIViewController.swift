import UIKit

extension UIViewController {
  // MARK: - UITextField animating group
  /// Конфигурации выдвижения клавиатуры снизу
  /// - Parameters:
  ///   - textFeild: UITextField
  ///   - distance: Int
  ///   - goUp: Bool
  func moveView(distance: Int, goUp: Bool) {
    let moveDuraction = 0.3
    let movement = CGFloat(goUp ? distance : -distance)
    UIView.animate(withDuration: moveDuraction, delay: 0, options: .beginFromCurrentState) {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    }
  }
}

  // MARK: - alert group
extension UIViewController {
  func showAlert(title: String, message: String, actions: [UIAlertAction]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for action in actions {
      alert.addAction(action)
    }
    DispatchQueue.main.async {
      self.present(alert, animated: true)
    }
  }
}

  // MARK: - gesture group
extension UIViewController {
  func addGestureRecognizer(action: Selector) {
    let gesture = UITapGestureRecognizer(target: self, action: action)
    gesture.numberOfTouchesRequired = 1
    gesture.numberOfTapsRequired = 1
    self.view.addGestureRecognizer(gesture)
  }
}

extension UIViewController {
  // MARK: - indicator group
  // экран индикатора при подгрузках
  func setLoadingScreen(tableView: UITableView, loadView: UIView, indicator: UIActivityIndicatorView) {
    let width: CGFloat = 50
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height ?? 0)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    indicator.style = .large
    indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    indicator.startAnimating()
    loadView.addSubview(indicator)
    tableView.addSubview(loadView)
    tableView.isScrollEnabled = false
  }

  func removeLoadingScreen(tableView: UITableView, indicator: UIActivityIndicatorView) {
    indicator.stopAnimating()
    indicator.isHidden = true
    tableView.isScrollEnabled = true
  }
}
