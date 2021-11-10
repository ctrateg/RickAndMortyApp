import UIKit
import Kingfisher

protocol CharactersTableViewInput: AnyObject {
  func goCard(characterCard: CharacterCardTVC)
  func setActivityIndicator()
  func removeActivityIndicator()
}

class CharactersTableViewController: UITableViewController, StoryboardCreatable {
  private var presenter: CharactersTableViewOutput?
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  private let searchBarController = UISearchController()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.presenter = CharactersTableViewPresenter(view: self)
    presenter?.protocolConfiguration(searchBar: self.searchBarController.searchBar, controller: self)
    request()
    searchBarConfiguration()
    configurationNavgiationC(title: "Characters")
  }

  private func request() {
    setLoadingScreen(tableView: self.tableView, loadView: self.loadView, indicator: self.indicator)
    presenter?.getCharactersReuqest(tableView: self.tableView)
    removeLoadingScreen(tableView: self.tableView, indicator: self.indicator)
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  private func searchBarConfiguration() {
    navigationItem.searchController = searchBarController
    searchBarController.searchBar.searchTextField.backgroundColor = .white
    searchBarController.searchBar.searchTextField.textColor = .black
    searchBarController.searchBar.searchTextField.tintColor = .systemGray
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let characterCard = CharacterCardTVC.createFromStoryboard as? CharacterCardTVC else { return }
    presenter?.rowClicked(card: characterCard, indexPath: indexPath)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.numberOfRows() ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharacterCell",
      for: indexPath) as? CharacterTableViewCell else {
        return UITableViewCell()
      }
    return presenter?.cellView(cell: cell, indexPath: indexPath) ?? UITableViewCell()
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    presenter?.didScroll(scrollView: scrollView)
  }
}

extension CharactersTableViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    presenter?.searchBarTextDidChange(searchBar: searchBar, searchText: searchText, tableView: self.tableView)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    presenter?.cancelSearching()
    searchBar.text = ""
    tableView.reloadData()
  }
}

extension CharactersTableViewController: CharactersTableViewInput {
  func goCard(characterCard: CharacterCardTVC) {
    show(characterCard, sender: nil)
  }

  func setActivityIndicator() {
    self.setLoadingScreen(tableView: self.tableView, loadView: self.loadView, indicator: self.indicator)
  }

  func removeActivityIndicator() {
    self.tableView.reloadData()
    self.removeLoadingScreen(tableView: self.tableView, indicator: self.indicator)
  }
}
