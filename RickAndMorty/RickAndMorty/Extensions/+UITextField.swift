import UIKit

extension UITextField {
  /// Добавление линии для текстовых полей
  /// - Parameter textField: UITextField
  func textFieldUnderLine(textField: UITextField) {
    let bottomLine = CALayer()
    let borderWidth = CGFloat(1.0)
    let hight = self.frame.height
    let width = self.frame.width
    bottomLine.frame = CGRect(x: 1, y: hight - borderWidth, width: width - 2, height: borderWidth)
    bottomLine.backgroundColor = UIColor.lightGray.cgColor
    self.borderStyle = .none
    self.layer.addSublayer(bottomLine)
    self.layer.masksToBounds = true
  }
}
