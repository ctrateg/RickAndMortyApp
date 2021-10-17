import UIKit

class CharacterTableViewCell: UITableViewCell {
  @IBOutlet weak var favoritIconOutlet: UIButton!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var charactetrStatus: UILabel!
  @IBOutlet weak var characterName: UILabel!
  var dataCellRequest: [CharacterResultDTO]?
  var dataCell: CharacterCache?
  @IBAction func characterInfoButton(_ sender: Any) {
    let characterCardVC = UIStoryboard(name: "CharacterCardUI", bundle: nil)
      .instantiateViewController(withIdentifier: "CharacterCardUI")
    characterCardVC.loadViewIfNeeded()
    characterCardVC.modalPresentationStyle = .fullScreen
  }
  @IBAction func likeButton(_ sender: Any) {
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    characterIcon.layer.cornerRadius = 26
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
