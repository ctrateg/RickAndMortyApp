import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
  super.viewDidLoad()
  navigationController?.isToolbarHidden = true
  tabBarController?.tabBar.isHidden = true
  }
}
