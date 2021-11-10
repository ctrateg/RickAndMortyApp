import UIKit

extension UIButton {
  func deleteImageChange() {
    self.setImage(UIImage(named: "LikeButton"), for: .normal)
    self.tintColor = .black
  }

  func saveImageChange() {
    self.setImage(
      UIImage(named: "LikeButtonFull"),
      for: .normal)
    self.tintColor = UIColor(named: "MainColor")
  }
  func pulseAnimatin(inputButton: UIButton) {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.toValue = 1.2
    animation.duration = 1.0
    animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    animation.autoreverses = true
    animation.repeatCount = .infinity
    inputButton.layer.add(animation, forKey: "pulsing")
  }
}
