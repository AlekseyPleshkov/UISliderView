//
//  UIFullScreenSliderViewController.swift
//  UISliderView
//
//  Created by Aleksey Pleshkov on 26.01.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit

final class UIFullScreenSliderViewController: UIViewController {

  // MARK: - Internal Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
  }
  
  // MARK: - Internal Methods
  
  func attach(fullScreenSlider: UIFullScreenSliderView) {
    view.addSubview(fullScreenSlider)
    
    NSLayoutConstraint.activate([
      fullScreenSlider.topAnchor.constraint(equalTo: view.topAnchor),
      fullScreenSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      fullScreenSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      fullScreenSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}
