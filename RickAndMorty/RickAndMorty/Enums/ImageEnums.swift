import UIKit

enum ImagesCell {
  static var favorite: UIImage { return UIImage(named: "LikeButton") ?? UIImage() }
  static var favoriteSelected: UIImage { return UIImage(named: "LikeButtonFull") ?? UIImage() }
  static var segue: UIImage { return UIImage(named: "InfoImage") ?? UIImage() }
}

enum ImagesPageView {
  static var emptyDot: UIImage { return UIImage(named: "emptyDot") ?? UIImage() }
  static var fullDot: UIImage { return UIImage(named: "fullDot") ?? UIImage() }
}

enum ImagesTabBar {
  static var characters: UIImage { return UIImage(named: "CharactersImage") ?? UIImage() }
  static var episodes: UIImage { return UIImage(named: "EpisodesImage") ?? UIImage() }
  static var favorites: UIImage { return UIImage(named: "FavoriteImage") ?? UIImage() }
  static var locations: UIImage { return UIImage(named: "LocationImage") ?? UIImage() }
  static var statistics: UIImage { return UIImage(named: "StatisticImage") ?? UIImage() }
}
