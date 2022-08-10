//
//  ViewController.swift
//  Example
//
//  Created by Aleksey Pleshkov on 26.01.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit
import UISliderView

final class ViewController: UIViewController {

  @IBOutlet weak var sliderView: UISliderView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sliderView.images = [
      URL(string: "https://images.unsplash.com/photo-1444076784383-69ff7bae1b0a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2024&q=100")!,
      URL(string: "https://images.unsplash.com/photo-1578664934514-789f4fb29160?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2024&q=100")!,
      URL(string: "https://images.unsplash.com/photo-1578739207984-3514f3dfa64c?ixlib=rb-1.2.1&auto=format&fit=crop&w=2024&q=100")!,
      URL(string: "https://images.unsplash.com/photo-1578426187131-a427d5f5306b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2024&q=100")!
    ]
    sliderView.delegate = self
    sliderView.viewController = self
    sliderView.fullScreenBackButtonImage = UIImage(named: "backButton")
//    sliderView.fullScreenImageContentMode = .scaleAspectFit
    sliderView.reloadData()
  }
}

// MARK: - UISliderViewDelegate

extension ViewController: UISliderViewDelegate {
  func sliderView(_ sliderView: UISliderView, didChangeSlideAt index: Int) {
    print("Did change slide at index: \(index)")
  }
  
  func sliderView(_ sliderView: UISliderView, didChangeFullScreenVisible isVisible: Bool) {
    print("Did change full screen visible: \(isVisible)")
  }
}
