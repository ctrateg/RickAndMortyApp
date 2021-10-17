import UIKit

class EpisodesTableViewCell: UITableViewCell {
  @IBOutlet weak var episodesTitle: UILabel!
  @IBOutlet weak var episodesNumber: UILabel!
  @IBAction func favoriteButton(_ sender: UIButton) {
  }
  @IBAction func sequeButton(_ sender: Any) {
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
