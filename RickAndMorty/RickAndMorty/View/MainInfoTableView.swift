import UIKit

class MainInfoTableView: UITableViewController {
  weak var delegate: MenuDelegate?
  private let appearance = UINavigationBarAppearance()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationControllerConfig()
  }
  /// Изменение визуальной составляющей NavigationController
  private func navigationControllerConfig() {
    let navigationBar = self.navigationController?.navigationBar
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "MenuIcon"),
      style: .plain,
      target: self,
      action: #selector(tapMenu))
    self.navigationItem.leftBarButtonItem?.tintColor = .white
    self.navigationItem.title = "Character"
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
  @objc func tapMenu() {
    delegate?.toggleMenu()
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MainInfoCell", for: indexPath)
    cell.textLabel?.text = "text" + String(indexPath.row)
    return cell
  }
}
