import UIKit

protocol EpisodesTableViewInput: AnyObject {
  func goCard(episodeCard: EpisodesCardTVC)
  func setActivityIndicator()
  func removeActivityIndicator()
}

class EpisodesTableViewController: UITableViewController, StoryboardCreatable {
  private var presenter: EpisodesTableViewOutput?
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.presenter = EpisodesTableViewPresenter(view: self)
    configurationNavgiationC(title: "Episodes")
    request()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }

  private func request() {
    setLoadingScreen(tableView: self.tableView, loadView: self.loadView, indicator: self.indicator)
    presenter?.getEpisodesRequest(tableView: self.tableView)
    removeLoadingScreen(tableView: self.tableView, indicator: self.indicator)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.numberOfRows() ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "EpisodesCell",
      for: indexPath) as? EpisodesTableViewCell else {
        return UITableViewCell()
      }
    return presenter?.cellView(cell: cell, indexPath: indexPath) ?? UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let episodeCard = EpisodesCardTVC.createFromStoryboard as? EpisodesCardTVC
    else { return }
    presenter?.rowClicked(card: episodeCard, indexPath: indexPath)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    presenter?.didScroll(scrollView: scrollView)
  }
}

extension EpisodesTableViewController: EpisodesTableViewInput {
  func goCard(episodeCard: EpisodesCardTVC) {
    show(episodeCard, sender: nil)
  }
  func setActivityIndicator() {
    self.setLoadingScreen(tableView: self.tableView, loadView: self.loadView, indicator: self.indicator)
  }
  func removeActivityIndicator() {
    self.tableView.reloadData()
    self.removeLoadingScreen(tableView: self.tableView, indicator: self.indicator)
  }
}
