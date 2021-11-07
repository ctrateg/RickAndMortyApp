import UIKit

class EpisodesFavoriteCell: UITableViewCell {
  @IBOutlet weak var episodesName: UILabel!
  @IBOutlet weak var episodesSubName: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
