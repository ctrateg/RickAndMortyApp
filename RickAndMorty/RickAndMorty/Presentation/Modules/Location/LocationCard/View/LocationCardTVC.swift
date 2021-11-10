import UIKit

protocol LocationCardInput: AnyObject {
  func showController(controller: UITableViewController)
  func presentActivityView(_ activityView: UIActivityViewController)
}

class LocationCardTVC: UITableViewController, StoryboardCreatable {
  private var presenter: LocationCardOutput?
  var locationURL: [String] = []
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.locationRequest(tableView: self.tableView, urlArray: locationURL)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = LocationCardPresenter(view: self)
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Location Card"
    self.shareButtonConfig()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.numberOfRowsInSection(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return presenter?.heightForHeaderInSection(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return presenter?.heightForRowAt(indexPath: indexPath) ?? 0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.didSelectRowAt(indexPath: indexPath)
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return presenter?.viewForHeaderInSection(tableView: tableView, section: section)
  }

  private func shareButtonConfig() {
    let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityAction))
    self.navigationItem.rightBarButtonItem = actionButton
  }

  @objc private func activityAction() {
    presenter?.sharedView()
  }
}

extension LocationCardTVC: LocationCardInput {
  func showController(controller: UITableViewController) {
    show(controller, sender: nil)
  }
  func presentActivityView(_ activityView: UIActivityViewController) {
    present(activityView, animated: true)
  }
}
