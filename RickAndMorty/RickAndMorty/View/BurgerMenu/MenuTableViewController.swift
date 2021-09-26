import UIKit

class MenuTableViewController: UITableViewController {
  weak var delegate: MenuDelegate?
  weak var titleDelegate: TitleNavigationDelegate?
  private let namesArray = ["Characters", "Episodes", "Location", "Statics", "Favorites"]
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = .white
    self.view.frame.size = CGSize(width: self.view.frame.width - 75, height: self.view.frame.height)
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return namesArray.count + 1
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    if indexPath.row == 0 {
      cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
      self.tableView.rowHeight = 155
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
      self.tableView.rowHeight = 55
      cell.textLabel?.text = namesArray[indexPath.row - 1]
      cell.textLabel?.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row != 0 {
      delegate?.toggleMenu()
      titleDelegate?.changeTitle(namesArray[indexPath.row - 1])
    }
  }
}
