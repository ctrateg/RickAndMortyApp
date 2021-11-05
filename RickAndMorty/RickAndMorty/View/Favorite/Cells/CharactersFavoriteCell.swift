import UIKit

class CharactersFavoriteCell: UITableViewCell {
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var characterStatus: UILabel!
  var dataCell: CharacterCache?
  weak var showService: ShowMethodProtocol?
  @IBAction func segueAction(_ sender: UIButton) {
    guard let presentVC = UIStoryboard(name: "CharactersUI", bundle: nil).instantiateViewController(
      withIdentifier: "CharacterCardTVC") as? CharacterCardTVC
    else { return }
    presentVC.characterURL.append(dataCell?.url ?? "")
    showService?.showCard(inputVC: presentVC)
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    characterIcon.layer.cornerRadius = 23.5
    characterIcon.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
