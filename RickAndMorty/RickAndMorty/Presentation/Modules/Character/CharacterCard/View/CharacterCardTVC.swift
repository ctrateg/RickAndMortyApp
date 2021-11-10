import UIKit

protocol CharacterCardInput: AnyObject {
  func showController(controller: UITableViewController)
  func presentActivityView(_ activityView: UIActivityViewController)
}

class CharacterCardTVC: UITableViewController, StoryboardCreatable {
  private var presenter: CharacterCardOutput?

  var characterURL: [String] = []
  private var collectionView: UICollectionView?
  private var loadView = UIView()
  private var indicator = UIActivityIndicatorView()
  private var flow: UICollectionViewFlowLayout?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = CharacterCardPresenter(view: self)
    self.shareButtonConfig()
    self.tableView.backgroundColor = .systemGray6
    self.presenter?.characterRequest(tableView: self.tableView, urlArray: characterURL)
  }

  private func shareButtonConfig() {
    let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityAction))
    self.navigationItem.rightBarButtonItem = actionButton
  }

  @objc private func activityAction() {
    presenter?.sharedView()
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return presenter?.heightForRowAt(indexPath: indexPath) ?? 0
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.numberOfRowsInSection(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return presenter?.cellConfiguration(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return presenter?.heightForHeaderInSection(section: section) ?? 0
  }

  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.didSelectRowAt(indexPath: indexPath)
  }
}

extension CharacterCardTVC: UICollectionViewDelegate, UICollectionViewDataSource {
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    collectionObject()
    return presenter?.viewForHeaderInSection(
      section: section,
      tableViewController: self,
      collectionView: self.collectionView ?? UICollectionView()
    )
  }

  private func collectionObject() {
    flow = UICollectionViewFlowLayout()
    flow?.scrollDirection = .horizontal
    flow?.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    flow?.itemSize = CGSize(width: 100, height: 150)
    collectionView = UICollectionView(
      frame: CGRect(x: 0, y: 40, width: tableView.frame.width, height: 155),
      collectionViewLayout: flow ?? UICollectionViewFlowLayout())
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter?.numberOfItemsInSectionCollection() ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return presenter?.cellForItemAtCollection(
      collectionView: collectionView,
      indexPath: indexPath) ?? UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter?.didSelectItemAtCollection(indexPath: indexPath)
  }
}

extension CharacterCardTVC: CharacterCardInput {
  func showController(controller: UITableViewController) {
    show(controller, sender: nil)
  }
  func presentActivityView(_ activityView: UIActivityViewController) {
    present(activityView, animated: true)
  }
}
