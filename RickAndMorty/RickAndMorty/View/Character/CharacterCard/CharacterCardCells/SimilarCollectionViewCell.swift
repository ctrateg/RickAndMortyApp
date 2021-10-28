import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageCollectionCell: UIImageView!
  @IBOutlet weak var nameCollectionCell: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    configurationCell()
  }
  private func configurationCell() {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOpacity = 0.4
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 2
    self.layer.cornerRadius = 10
    self.imageCollectionCell.layer.cornerRadius = 8
  }
}
