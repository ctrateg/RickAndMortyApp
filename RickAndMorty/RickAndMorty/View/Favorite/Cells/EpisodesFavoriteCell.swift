import UIKit

class EpisodesFavoriteCell: UITableViewCell {
  @IBOutlet weak var episodesName: UILabel!
  @IBOutlet weak var episodesSubName: UILabel!
  var dataCell: EpisodesCache?
  weak var showService: ShowMethodProtocol?
  @IBAction func segueAction(_ sender: Any) {
    guard let presentVC = UIStoryboard(name: "EpisodesUI", bundle: nil).instantiateViewController(
      withIdentifier: "EpisodesCardTVC") as? EpisodesCardTVC
    else { return }
    presentVC.episodesURL.append(dataCell?.url ?? "")
    showService?.showCard(inputVC: presentVC)
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
