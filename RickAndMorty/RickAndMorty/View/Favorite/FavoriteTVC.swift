import UIKit
import Kingfisher

class FavoriteTVC: UITableViewController {
  private let appearance = UINavigationBarAppearance()
  private var favoriteChar: [CharacterCache] = []
  @IBOutlet weak var subNavigationBar: UINavigationBar!

  private weak var loadDataDelegate: UserCacheLoadDelegate?
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadDataDelegate = UserCacheData.shared
    configurationNavgiationC()
    loadData()
  }
  func loadData() {
    DispatchQueue.global(qos: .background).async {
      self.loadDataDelegate?.loadItems { responce in
        self.favoriteChar = responce
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return favoriteChar.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharactersFavoriteCell",
      for: indexPath) as? CharactersFavoriteCell else {
        return UITableViewCell()
    }
    return cellConfiguration(cell: cell, data: favoriteChar[indexPath.row], index: indexPath.row)
  }
  private func cellConfiguration(cell: CharactersFavoriteCell, data: CharacterCache?, index: Int) -> UITableViewCell {
    let imageURL = URL(string: data?.image ?? "")
    cell.characterName.text = data?.name
    cell.characterIcon.kf.setImage(with: imageURL)
    switch data?.status {
    case "Alive":
      cell.characterStatus.textColor = .green
      cell.characterStatus.text = "\u{2022}" + (data?.status ?? "")
      cell.favoriteButtonOutlet.isHidden = false
    case "Dead":
      cell.characterStatus.textColor = .red
      cell.characterStatus.text = "\u{2022}" + (data?.status ?? "")
      cell.favoriteButtonOutlet.isHidden = true
    default:
      cell.characterStatus.text = ""
    }
    cell.dataCellRequest = data
    cell.indexPathRow = index
    return cell
  }
  private func configurationNavgiationC() {
    let navigationBar = self.navigationController?.navigationBar
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "MainColor")
    appearance.shadowColor = .clear
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    self.navigationItem.title = "In App Time"
    subNavigationBar.standardAppearance = appearance
    navigationBar?.standardAppearance = appearance
    navigationBar?.scrollEdgeAppearance = navigationBar?.standardAppearance
  }
}
