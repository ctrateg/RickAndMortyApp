//
//  PreviewViewController.swift
//  RickAndMorty
//
//  Created by Евгений Васильев on 06.09.2021.
//

import UIKit

class PreviewViewController: UIViewController {
  @IBOutlet weak var previewImage: UIImageView!
  @IBOutlet weak var previewPCOutlet: UIPageControl!
  @IBAction func skipButton(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginTVC = storyboard.instantiateViewController(identifier: "LoginStoryboard")
    loginTVC.loadViewIfNeeded()
    loginTVC.modalPresentationStyle = .fullScreen
    present(loginTVC, animated: true)
  }
    @IBAction func previewPCAction(_ sender: Any) {
  previewImage.image = UIImage(named: "hello\(previewPCOutlet.currentPage + 1)")
  }
  override func viewDidLoad() {
  super.viewDidLoad()
  previewImage.image = UIImage(named: "hello1")
  // toDo пустые кнопки pagecontroller
  }
}
