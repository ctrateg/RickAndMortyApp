import UIKit

class LocationFavoriteCell: UITableViewCell {
  @IBOutlet weak var locationName: UILabel!
  var dataCell: LocationCache?
  weak var showService: ShowMethodProtocol?
  @IBAction func segueAction(_ sender: UIButton) {
    guard let presentVC = UIStoryboard(name: "LocationUI", bundle: nil).instantiateViewController(
      withIdentifier: "LocationCardTVC") as? LocationCardTVC
    else { return }
    presentVC.locationURL.append(dataCell?.url ?? "")
    showService?.showCard(inputVC: presentVC)
  }
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
