import UIKit

class CharactersTableView: UITableViewController {
  private lazy var userCacheData = {
    return UserCacheData()
  }
  private lazy var informatorObj = {
    return Informator()
  }
  private var characterCache: [CharacterCache] = []
  private var tagCharacter = "character"
  private var loadMoreStatus = false
  private var page = 1
  private let loadView = UIView()
  private let indicator = UIActivityIndicatorView()
  override func viewDidLoad() {
    super.viewDidLoad()
    userCacheData().loadItems { [weak self] responce in
      self?.characterCache = responce
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return characterCache.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CharacterCell",
      for: indexPath) as? CharacterTableViewCell else {
        return UITableViewCell()
    }
    let data = characterCache[indexPath.row]
    cell.characterName.text = data.name
    guard let dataImage = data.image else { return UITableViewCell() }
    cell.characterIcon.image = UIImage(data: dataImage)
    switch data.status {
    case "Alive":
      cell.charactetrStatus.textColor = .green
      cell.charactetrStatus.text = "\u{2022}" + (data.status ?? "")
    case "Dead":
      cell.charactetrStatus.textColor = .red
      cell.charactetrStatus.text = "\u{2022}" + (data.status ?? "")
    default:
      cell.charactetrStatus.text = ""
    }
    return cell
  }
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    let deltaOffset = maximumOffset - currentOffset
    if deltaOffset <= 0 {
      loadMore()
    }
  }
  func loadMore() {
    if !loadMoreStatus {
    self.loadMoreStatus = true
    self.setLoadingScreen()
    loadMoreBegin(tag: tagCharacter) {(_: Int) -> Void in
      self.tableView.reloadData()
      self.loadMoreStatus = false
      self.removeLoadingScreen()
    }
    }
  }

  func loadMoreBegin(tag: String, loadMoreEnd: @escaping(Int) -> Void) {
    DispatchQueue.global(qos: .default).async {
      self.page += 1
      self.informatorObj().takeInCache(tag: tag, page: String(self.page))
      self.userCacheData().loadItems { [weak self] responce in
        self?.characterCache = responce
      }
      sleep(2)
      DispatchQueue.main.async {
      loadMoreEnd(0)
      }
    }
  }

  // экран индикатора при подгрузках
  func setLoadingScreen() {
    let width: CGFloat = 50
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height ?? 0)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    indicator.style = .medium
    indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    indicator.startAnimating()
    loadView.addSubview(indicator)
    tableView.addSubview(loadView)
    tableView.isScrollEnabled = false
    }

  func removeLoadingScreen() {
    indicator.stopAnimating()
    indicator.isHidden = true
    tableView.isScrollEnabled = true
  }
}
