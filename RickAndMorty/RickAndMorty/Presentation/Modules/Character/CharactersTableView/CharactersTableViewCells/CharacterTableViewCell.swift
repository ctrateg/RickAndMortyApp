import UIKit
import CoreData

class CharacterTableViewCell: UITableViewCell, TableViewsCellInput {
  @IBOutlet weak var characterIcon: UIImageView!
  @IBOutlet weak var characterName: UILabel!
  @IBOutlet weak var characterStatus: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  var presenter: TableViewsCellOutput?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.presenter = TableViewsCellPresenter(view: self)
    characterIcon.layer.cornerRadius = 23.5
    characterIcon.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  @IBAction func favoriteButton(_ sender: UIButton) {
    presenter?.tapFavoriteButton(favoriteButton: sender)
  }
}
