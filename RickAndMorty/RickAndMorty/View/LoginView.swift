//
//  Login.swift
//  RickAndMorty
//
//  Created by Евгений Васильев on 03.09.2021.
//

import UIKit

class Login: UIViewController {
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBAction func loginButton(_ sender: Any) {
  }
  let showPasswordButton = UIButton(type: .custom)
  let eyeImage = UIImage(systemName: "eye.fill")
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    tabBarController?.tabBar.isHidden = true
    loginButtonOutlet.layer.cornerRadius = 8
    showPasswordButton.setImage(eyeImage, for: .normal)
    showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    showPasswordButton.sizeToFit()
    passwordField.isSecureTextEntry.toggle()
    passwordField.rightView = showPasswordButton
    passwordField.rightViewMode = .always
  }
  @objc func showPassword() {
    passwordField.isSecureTextEntry.toggle()
  }
}
