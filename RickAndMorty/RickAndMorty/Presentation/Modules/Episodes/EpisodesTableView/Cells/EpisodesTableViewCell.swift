import UIKit
import CoreData

class EpisodesTableViewCell: UITableViewCell, TableViewsCellInput {
  @IBOutlet weak var episodesTitle: UILabel!
  @IBOutlet weak var episodesNumber: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  var presenter: TableViewsCellOutput?
  override func awakeFromNib() {
    super.awakeFromNib()
    self.presenter = TableViewsCellPresenter(view: self)
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  @IBAction func favoriteButton(_ sender: UIButton) {
    presenter?.tapFavoriteButton(favoriteButton: favoriteButton)
  }
}
