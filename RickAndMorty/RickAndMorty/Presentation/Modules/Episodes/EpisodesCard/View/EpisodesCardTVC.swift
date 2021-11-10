import UIKit

protocol EpisodesCardInput: AnyObject {
  func showController(controller: UITableViewController)
  func presentActivityView(_ activityView: UIActivityViewController)
}

class EpisodesCardTVC: UITableViewController, StoryboardCreatable {
  private var presenter: EpisodesCardOutput?

  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()

  var episodesURL: [String] = []
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.episodesRequest(tableView: self.tableView, urlArray: episodesURL)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = EpisodesCardPresenter(view: self)
    self.tableView.backgroundColor = .systemGray6
    self.navigationItem.title = "Episode Card"
    self.shareButtonConfig()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter?.numberOfRowsInSection(section: section) ?? 0
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    presenter?.heightForHeaderInSection(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    presenter?.heightForRowAt(indexPath: indexPath) ?? 0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.didSelectRowAt(indexPath: indexPath)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    presenter?.viewForHeaderInSection(tableView: tableView, section: section)
  }

  private func shareButtonConfig() {
    let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityAction))
    self.navigationItem.rightBarButtonItem = actionButton
  }

  @objc private func activityAction() {
    presenter?.sharedView()
  }
}

extension EpisodesCardTVC: EpisodesCardInput {
  func showController(controller: UITableViewController) {
    show(controller, sender: nil)
  }
  func presentActivityView(_ activityView: UIActivityViewController) {
    present(activityView, animated: true)
  }
}
