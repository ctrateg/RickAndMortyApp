import UIKit
import Locksmith

class Login: UIViewController {
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButtonOutlet: UIButton!
  @IBOutlet weak var errorMessage: UILabel!
  let showPasswordButton = UIButton(type: .custom)
  let eyeImage = UIImage(systemName: "eye.fill")
  let account = KeyChainAccount(username: "admin", password: "admin1")
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
  }
  func textFieldLine(textField: UITextField) {
    let bottomLine = CALayer()
    let borderWidth = CGFloat(1.0)
    let hight = textField.frame.height
    let width = textField.frame.width
    bottomLine.frame = CGRect(x: 1, y: hight - borderWidth, width: width - 2, height: borderWidth)
    bottomLine.backgroundColor = UIColor.lightGray.cgColor
    textField.borderStyle = .none
    bottomLine.borderWidth = borderWidth
    textField.layer.addSublayer(bottomLine)
    textField.layer.masksToBounds = true
  }
    @IBAction func loginClearField(_ sender: Any) {
      loginField.text = ""
      loginField.textColor = .black
    }
    @IBAction func passwordClearField(_ sender: Any) {
      passwordField.text = ""
      passwordField.textColor = .black
    }
    @IBAction func loginButton(_ sender: Any) {
    let dictLogin = Locksmith.loadDataForUserAccount(userAccount: loginField.text ?? "", inService: "KeyChainAccount")
    if passwordField.text == dictLogin?["password"] as? String {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let mainTVC = storyboard.instantiateViewController(identifier: "ContainerViewController")
      mainTVC.loadViewIfNeeded()
      mainTVC.modalPresentationStyle = .fullScreen
      present(mainTVC, animated: true)
    } else {
      errorMessage.isHidden = false
      loginField.textColor = .red
      passwordField.textColor = .red
    }
  }
  @IBAction func doneButtonLoginTF(_ sender: UITextField) {
    sender.resignFirstResponder()
  }
  @objc func showPassword() {
    passwordField.isSecureTextEntry.toggle()
  }
  func showPasswordButtonSetting() {
    showPasswordButton.setImage(eyeImage, for: .normal)
    showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    showPasswordButton.sizeToFit()
    showPasswordButton.tintColor = .darkGray
  }
  func passwordFieldButton() {
    passwordField.rightView = showPasswordButton
    passwordField.rightViewMode = .always
  }
}
