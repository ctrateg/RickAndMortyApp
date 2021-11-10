import UIKit
import Kingfisher
import CoreData

protocol FavoritesViewInput: AnyObject {
  func showController(controller: UITableViewController)
}

class FavoritesViewController: UITableViewController, StoryboardCreatable {
  @IBOutlet weak var segmenteController: UISegmentedControl!
  @IBOutlet weak var subNavigationBar: UINavigationBar!

  private var presenter: FavoritesViewOutput?

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = FavoritesPresenter(view: self)
    configurationNavgiationC(title: "Favorites")
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  @IBAction func segmentAction(_ sender: UISegmentedControl) {
    presenter?.changeSegmentStatus(tag: segmenteController.selectedSegmentIndex)
    tableView.reloadData()
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.didSelectRowAt(indexPath: indexPath)
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter?.numberOfRowsInSection() ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let status = segmenteController.selectedSegmentIndex
    return presenter?.cellForRowAt(status: status, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let segmentIndex = self.segmenteController.selectedSegmentIndex
    return presenter?.deletAction(segmentIndex: segmentIndex, indexPath: indexPath, tableView: tableView)
  }
}

extension FavoritesViewController: FavoritesViewInput {
  func showController(controller: UITableViewController) {
    show(controller, sender: nil)
  }
}
