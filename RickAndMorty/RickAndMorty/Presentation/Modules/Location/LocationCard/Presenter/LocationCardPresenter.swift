import UIKit
import Kingfisher
import CoreData

protocol LocationCardOutput {
  init(view: LocationCardInput)
  func locationRequest(tableView: UITableView, urlArray: [String])
  func numberOfRowsInSection(section: Int) -> Int
  func heightForHeaderInSection(section: Int) -> CGFloat
  func heightForRowAt(indexPath: IndexPath) -> CGFloat
  func didSelectRowAt(indexPath: IndexPath)
  func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView?
  func sharedView()
}

class LocationCardPresenter: LocationCardOutput {
  private weak var serviceRequest: SingleRequestProtocol?
  private weak var view: LocationCardInput?
  private var headerConfigProtocol: LocationHeaderProtocol?

  private var deletObject: LocationCache?
  private var locationRequestResult: [LocationResultsDTO]?
  private var charactersDTO: CharacterDTO?
  private var titles: [String] = ["Type", "Dimension", "Date"]
  private var characterRequestResult: [CharacterResultsDTO]?
  private var cardArray: [String]?
  private var imageCharacters: [UIImage] = []
  private var clickedTopButton = false

  required init(view: LocationCardInput) {
    self.view = view
    self.serviceRequest = RequestServiceAPI.shared
  }

  func locationRequest(tableView: UITableView, urlArray: [String]) {
    DispatchQueue.global(qos: .background).async {
      self.serviceRequest?.requestForLocation(urlArray: urlArray) { [weak self] responce in
        self?.locationRequestResult = responce
        self?.cardArray = [
          responce[0].type,
          responce[0].dimension,
          String(self?.dateFormatterConfiguration(data: responce[0].created) ?? "")
        ]

        self?.requestCharacters(urlArray: responce[0].residents)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          tableView.reloadData()
        }
      }
    }
  }

  private func requestCharacters(urlArray: [String]) {
    self.serviceRequest?.requestForCharacter(urlArray: urlArray) { [weak self] responce in
      self?.characterRequestResult = responce
    }
  }
  private func dateFormatterConfiguration(data: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: data) else { return "" }
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter.string(from: date)
  }

  func numberOfRowsInSection(section: Int) -> Int {
    switch section {
    case 0:
      return cardArray?.count ?? 0
    default:
      return locationRequestResult?[0].residents.count ?? 0
    }
  }

  func heightForHeaderInSection(section: Int) -> CGFloat {
    switch section {
    case 0:
      return 124
    default:
      return 38
    }
  }

  func heightForRowAt(indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 44
    default:
      return 60
    }
  }

  func didSelectRowAt(indexPath: IndexPath) {
    switch indexPath.section {
    case 1:
      guard let presentVC = CharacterCardTVC.createFromStoryboard as? CharacterCardTVC
      else { return }
      presentVC.characterURL.append(self.characterRequestResult?[indexPath.row].url ?? "")
      view?.showController(controller: presentVC)
    default: return
    }
  }

  func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cellInfo = tableView.dequeueReusableCell(
        withIdentifier: "LocationInfoCell",
        for: indexPath) as? LocationInfoCell else { return UITableViewCell() }
      cellInfo.detailLabel.text = cardArray?[indexPath.row]
      cellInfo.titleLabel.text = titles[indexPath.row]
      if cellInfo.detailLabel.text?.isEmpty == true {
        cellInfo.detailLabel?.text = "unknown"
      }
      return cellInfo
    default:
      guard let cellCharacter = tableView.dequeueReusableCell(
        withIdentifier: "LocationCharacterCell",
        for: indexPath) as? LocationCharacterCell else { return UITableViewCell() }
      let data = characterRequestResult?[indexPath.row]
      let imageURL = URL(string: data?.image ?? "")
      if LocalDataManager.favoriteCharacters.contains(where: { $0.id == (data?.id ?? 0) }) {
        cellCharacter.favoriteButton.setImage(ImagesCell.favoriteSelected, for: .normal)
        cellCharacter.favoriteButton.tintColor = CustomColors.mainColor
        cellCharacter.deletObject = LocalDataManager.favoriteCharacters.first { $0.id == (data?.id ?? 0) }
        cellCharacter.clicked = true
      } else {
        cellCharacter.favoriteButton.setImage(ImagesCell.favorite, for: .normal)
        cellCharacter.favoriteButton.tintColor = .darkGray
        cellCharacter.clicked = false
      }
      cellCharacter.characterName.text = data?.name
      switch data?.status {
      case "Alive":
        cellCharacter.characterStatus.textColor = .green
        cellCharacter.characterStatus.text = "\u{2022}" + (data?.status ?? "")
        cellCharacter.favoriteButton.isHidden = false
      case "Dead":
        cellCharacter.characterStatus.textColor = .red
        cellCharacter.characterStatus.text = "\u{2022}" + (data?.status ?? "")
        cellCharacter.favoriteButton.isHidden = true
      default:
        cellCharacter.characterStatus.text = ""
      }
      cellCharacter.dataCellRequest = data
      cellCharacter.characterImage.kf.setImage(with: imageURL)

      return cellCharacter
    }
  }

  func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
    guard let locationResult = locationRequestResult?[0] else { return UIView() }
    headerConfigProtocol = LocationHeaderConfigurations.shared
    LocationHeaderConfigurations.shared.saveObject = locationResult
    switch section {
    case 0:
      return headerConfigProtocol?.topHeaderConfiguration(dataInput: locationResult, tableView: tableView)
    default:
      return headerConfigProtocol?.middleHeaderConfiguration(text: "CHARACTERS IN LOCATION", tableView: tableView)
    }
  }

  func sharedView() {
    let returnValue = [locationRequestResult?[0].name]
    let activityView = UIActivityViewController(activityItems: returnValue as [Any], applicationActivities: nil)
    view?.presentActivityView(activityView)
  }
}
