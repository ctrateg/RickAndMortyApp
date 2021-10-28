import UIKit

class CharacterEpisodesCell: UITableViewCell {
  var clicked = false
  @IBOutlet weak var likeButtonOutlet: UIButton!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var desciption: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  @IBAction func likeButtonAction(_ sender: UIButton) {
    if clicked {
      likeButtonOutlet.setImage(UIImage(named: "LikeButton"), for: .normal)
      likeButtonOutlet.tintColor = .darkGray
    } else {
      likeButtonOutlet.setImage(UIImage(named: "LikeButtonFull"), for: .normal)
      likeButtonOutlet.tintColor = UIColor(named: "MainColor")
    }
    clicked.toggle()
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}