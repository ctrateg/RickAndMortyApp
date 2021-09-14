import UIKit

protocol MainInfoTableViewDelegate {
  func toggleMenu()
}

class MainInfoTableView: UITableViewController {
  var delegate: MainInfoTableViewDelegate?
  @IBAction func burgerMenuButton(_ sender: UIBarButtonItem) {
    delegate?.toggleMenu()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
}
