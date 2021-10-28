import UIKit

class EpisodesTableViewCell: UITableViewCell {
  @IBOutlet weak var episodesTitle: UILabel!
  @IBOutlet weak var episodesNumber: UILabel!
  @IBOutlet weak var favoriteButtonOutlet: UIButton!
  var clicked = false
  @IBAction func favoriteButton(_ sender: UIButton) {
    if clicked {
      favoriteButtonOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      favoriteButtonOutlet.tintColor = .darkGray
    } else {
      favoriteButtonOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      favoriteButtonOutlet.tintColor = UIColor(named: "MainColor")
    }
    clicked.toggle()
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
