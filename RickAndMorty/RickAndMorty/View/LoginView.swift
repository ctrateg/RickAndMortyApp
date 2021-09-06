import UIKit
import Locksmith

class Login: UIViewController {
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButtonOutlet: UIButton!
    // toDo сделать проверку, прикрутить алерты на ошибку, изменить визуал текст филдов, отступ прикрутить
  let showPasswordButton = UIButton(type: .custom)
  let eyeImage = UIImage(systemName: "eye.fill")
  let account = KeyChainAccount(username: "admin", password: "admin1")
  override func viewDidLoad() {
    super.viewDidLoad()
    try? account.createInSecureStore()
    loginButtonOutlet.layer.cornerRadius = 8
    showPasswordButtonSetting()
    passwordFieldButton()
  }
  @IBAction func loginButton(_ sender: Any) {
    let dictLogin = Locksmith.loadDataForUserAccount(userAccount: "admin", inService: "KeyChainAccount")
    if passwordField.text == dictLogin?["password"] as? String {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let mainTVC = storyboard.instantiateViewController(identifier: "MainInfoTableView")
      mainTVC.loadViewIfNeeded()
      mainTVC.modalPresentationStyle = .fullScreen
      present(mainTVC, animated: true)
    }
  }
  @IBAction func doneButtonLoginTF(_ sender: UITextField) {
    sender.resignFirstResponder()
  }
  @IBAction func returnButtonPasswordTf(_ sender: UITextField) {
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
    passwordField.isSecureTextEntry.toggle()
    passwordField.rightView = showPasswordButton
    passwordField.rightViewMode = .always
  }
}
