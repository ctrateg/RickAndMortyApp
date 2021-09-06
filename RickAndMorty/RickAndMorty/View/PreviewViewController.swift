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
  @IBAction func previewPCAction(_ sender: Any) {
  previewImage.image = UIImage(named: "hello\(previewPCOutlet.currentPage + 1)")
  }

  override func viewDidLoad() {
  super.viewDidLoad()
  previewImage.image = UIImage(named: "hello1")
  // toDo пустые кнопки pagecontroller
  // previewPageControl.customPageControl(dotFillColor: .white, dotBorderColor: UIColor(named: "MainColor") ?? .black, dotBorderWidth: 1)
  }
}
