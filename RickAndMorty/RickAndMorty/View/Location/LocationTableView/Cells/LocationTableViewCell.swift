import UIKit

class LocationTableViewCell: UITableViewCell {
  @IBOutlet weak var favoriteButtonOutlet: UIButton!
  @IBOutlet weak var locationName: UILabel!
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
