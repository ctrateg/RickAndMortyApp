import UIKit
import Locksmith

protocol LoginViewInput: AnyObject {
  func showAlert()
  func goMain()
}

class LoginViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  private let showPasswordButton = UIButton(type: .custom)
  var presenter: LoginViewOutput?

  private let showImage = UIImage(named: "visibleEye")
  private let account = KeyChainAccount(username: "Rick", password: "Morty")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = LoginPresenter(view: self, account: self.account)
    addGestureRecognizer(action: #selector(keyboardClose(_ :)))
    self.loginField.textFieldUnderLine(textField: self.loginField)
    self.passwordField.textFieldUnderLine(textField: self.passwordField)
    self.showPasswordButtonSetting()
    self.passwordFieldButton()
    let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    pulseAnimation.duration = 2
    pulseAnimation.fromValue = 0.4
    pulseAnimation.toValue = 1
    pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    pulseAnimation.autoreverses = true
    pulseAnimation.repeatCount = .greatestFiniteMagnitude
    self.loginButton.layer.add(pulseAnimation, forKey: "animateOpacity")
  }

  @IBAction func cleanLoginField(_ sender: Any) {
    self.loginField.textColor = .black
    self.loginField.text = ""
    moveView(distance: -87, goUp: true)
  }

  @IBAction func cleanPasswordField(_ sender: Any) {
    passwordField.textColor = .black
    passwordField.text = ""
    moveView(distance: -124, goUp: true)
  }

  @IBAction func loginDidEndEditing(_ sender: Any) {
    moveView(distance: -87, goUp: false)
  }

  @IBAction func passwordDidEndEditing(_ sender: Any) {
    moveView(distance: -124, goUp: false)
  }

  @IBAction func touchLoginButton(_ sender: Any) {
    presenter?.tapLoginButton(loginField: self.loginField, passwordField: self.passwordField)
  }

  @IBAction func doneButtonLogin(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  @IBAction func doneButtonPassword(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  /// Конфигурация кнопки скрытия / отображения пароля
  private func showPasswordButtonSetting() {
    showPasswordButton.frame = CGRect(x: 0, y: 0, width: 22, height: 15)
    showPasswordButton.setImage(showImage, for: .normal)
    showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    showPasswordButton.sizeToFit()
    showPasswordButton.tintColor = .darkGray
  }

  /// Показать или скрыть пароль в поле
  private func passwordFieldButton() {
    passwordField.rightView = showPasswordButton
    passwordField.rightViewMode = .always
  }

  @objc private func keyboardClose(_ sender: UITapGestureRecognizer) {
    self.loginField.resignFirstResponder()
    self.passwordField.resignFirstResponder()
  }

  @objc func showPassword() {
    presenter?.passwordSecurityToggle(passwordField: passwordField)
  }
}

extension LoginViewController: LoginViewInput {
  func showAlert() {
    loginField.textColor = .red
    passwordField.textColor = .red
    showAlert(
      title: "Error",
      message: "Incorrect Login or Password",
      actions: [UIAlertAction(title: "OK", style: .default, handler: nil)]
    )
  }

  func goMain() {
    passwordField.textColor = .black
    loginField.textColor = .black
    show(TabBarViewController.createFromStoryboard, sender: nil)
  }
}
