import Locksmith
import UIKit

protocol LoginViewOutput: AnyObject {
  init(view: LoginViewInput, account: KeyChainAccount)
  func tapLoginButton(loginField: UITextField, passwordField: UITextField)
  func passwordSecurityToggle(passwordField: UITextField)
}

class LoginPresenter: LoginViewOutput {
  weak var view: LoginViewInput?
  let account: KeyChainAccount

  required init(view: LoginViewInput, account: KeyChainAccount) {
    self.view = view
    self.account = account
    try? account.createInSecureStore()
  }

  func tapLoginButton(loginField: UITextField, passwordField: UITextField) {
    let dictLogin = Locksmith.loadDataForUserAccount(userAccount: loginField.text ?? "", inService: "KeyChainAccount")
    if passwordField.text == dictLogin?["password"] as? String {
      view?.goMain()
    } else {
      view?.showAlert()
    }
  }

  func passwordSecurityToggle(passwordField: UITextField) {
    passwordField.isSecureTextEntry.toggle()
  }
}
