import UIKit

protocol LocationTableViewInput: AnyObject {
  func goCard(episodeCard: LocationCardTVC)
  func setActivityIndicator()
  func removeActivityIndicator()
}

class LocationTableViewController: UITableViewController, StoryboardCreatable {
  private var presenter: LocationTableViewOutput?
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private let appearance = UINavigationBarAppearance()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.presenter = LocationTableViewPresenter(view: self)
    configurationNavgiationC(title: "Locations")
    request()
  }

  private func request() {
    setLoadingScreen(tableView: self.tableView, loadView: self.loadView, indicator: self.indicator)
    presenter?.getLocationsRequest(tableView: self.tableView)
    removeLoadingScreen(tableView: self.tableView, indicator: self.indicator)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.numberOfRows() ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "LocationCell",
      for: indexPath) as? LocationTableViewCell else {
        return UITableViewCell()
    }
    return presenter?.cellView(cell: cell, indexPath: indexPath) ?? UITableViewCell()
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let locationCard = LocationCardTVC.createFromStoryboard as? LocationCardTVC
    else { return }
    presenter?.rowClicked(card: locationCard, indexPath: indexPath)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    presenter?.didScroll(scrollView: scrollView)
  }
  }
extension LocationTableViewController: LocationTableViewInput {
  func goCard(episodeCard: LocationCardTVC) {
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
