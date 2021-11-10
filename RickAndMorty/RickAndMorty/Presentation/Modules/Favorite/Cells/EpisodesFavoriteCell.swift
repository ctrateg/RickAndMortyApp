import UIKit

class EpisodesFavoriteCell: UITableViewCell {
  @IBOutlet weak var episodesName: UILabel!
  @IBOutlet weak var episodesSubName: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
