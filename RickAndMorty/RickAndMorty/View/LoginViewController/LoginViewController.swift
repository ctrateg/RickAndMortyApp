import UIKit
import Locksmith

class LoginViewController: UIViewController {
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButtonOutlet: UIButton!
  @IBOutlet weak var errorMessage: UILabel!

  private let showPasswordButton = UIButton(type: .custom)
  private let eyeImage = UIImage(systemName: "eye.fill")
  private let account = KeyChainAccount(username: "Rick", password: "Morty")

  private var gesture = UITapGestureRecognizer()
  @IBAction func didEndEditingLogin(_ sender: UITextField) {
    moveAnimtating(textFeild: loginField, distance: -85, goUp: false)
  }
  @IBAction func didEndEdditingPassword(_ sender: UITextField) {
    moveAnimtating(textFeild: passwordField, distance: -125, goUp: false)
  }

  @IBAction func loginClearField(_ sender: Any) {
    loginField.text = ""
    loginField.textColor = .black
    moveAnimtating(textFeild: loginField, distance: -85, goUp: true)
  }

  @IBAction func passwordClearField(_ sender: Any) {
    passwordField.text = ""
    passwordField.textColor = .black
    moveAnimtating(textFeild: passwordField, distance: -125, goUp: true)
  }

  @IBAction func loginButton(_ sender: Any) {
    let dictLogin = Locksmith.loadDataForUserAccount(userAccount: loginField.text ?? "", inService: "KeyChainAccount")
    if passwordField.text == dictLogin?["password"] as? String {
      let storyboard = UIStoryboard(name: "TabBarUI", bundle: nil)
      let mainTVC = storyboard.instantiateViewController(identifier: "TabBarViewController")
      mainTVC.loadViewIfNeeded()
      mainTVC.modalPresentationStyle = .fullScreen
      show(mainTVC, sender: nil)
    } else {
      let alert = UIAlertController(title: "Error", message: "This login or password not found", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      present(alert, animated: true)
      errorMessage.isHidden = false
      loginField.textColor = .red
      passwordField.textColor = .red
    }
  }

  @IBAction func doneButtonLoginTF(_ sender: UITextField) {
    sender.resignFirstResponder()
  }
  @IBAction func doneButtonPasswordTF(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.modalPresentationStyle = .fullScreen
    errorMessage.isHidden = true
    try? account.createInSecureStore()
    loginButtonOutlet.layer.cornerRadius = 8
    textFieldLine(textField: loginField)
    textFieldLine(textField: passwordField)
    showPasswordButtonSetting()
    passwordFieldButton()
    configurateionGesture()
  }
  /// Закрытие клавиатуры по нажатию вне текстовых полей
  private func configurateionGesture() {
    gesture = UITapGestureRecognizer(target: self, action: #selector(keyboardClose(_:)))
    gesture.numberOfTouchesRequired = 1
    gesture.numberOfTapsRequired = 1
    self.view.addGestureRecognizer(gesture)
  }

  @objc func keyboardClose(_ sender: UITapGestureRecognizer) {
    loginField.resignFirstResponder()
    passwordField.resignFirstResponder()
  }
  /// Конфигурации выдвижения клавиатуры снизу
  /// - Parameters:
  ///   - textFeild: UITextField
  ///   - distance: Int
  ///   - goUp: Bool
  private func moveAnimtating(textFeild: UITextField, distance: Int, goUp: Bool) {
    let moveDuraction = 0.3
    let movement = CGFloat(goUp ? distance : -distance)
    UIView.animate(withDuration: moveDuraction, delay: 0, options: .beginFromCurrentState) {
      self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    }
  }
  /// Добавление линии для текстовых полей
  /// - Parameter textField: UITextField
  private func textFieldLine(textField: UITextField) {
    let bottomLine = CALayer()
    let borderWidth = CGFloat(1.0)
    let hight = textField.frame.height
    let width = textField.frame.width
    bottomLine.frame = CGRect(x: 1, y: hight - borderWidth, width: width - 2, height: borderWidth)
    bottomLine.backgroundColor = UIColor.lightGray.cgColor
    textField.borderStyle = .none
    textField.layer.addSublayer(bottomLine)
    textField.layer.masksToBounds = true
  }

  @objc func showPassword() {
    passwordField.isSecureTextEntry.toggle()
  }
  /// Конфигурации боковой кнопки
  private func showPasswordButtonSetting() {
    showPasswordButton.setImage(eyeImage, for: .normal)
    showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    showPasswordButton.sizeToFit()
    showPasswordButton.tintColor = .darkGray
  }
  /// Скрыть или показать пароль в поле 
  private func passwordFieldButton() {
    passwordField.rightView = showPasswordButton
    passwordField.rightViewMode = .always
  }
}
