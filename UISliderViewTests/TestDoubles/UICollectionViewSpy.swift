//
//  UICollectionViewSpy.swift
//  UISliderViewTests
//
//  Created by Aleksey Pleshkov on 01.02.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit

final class UICollectionViewSpy: UICollectionView {
  
  // MARK: - Public Properties
  
  private(set) var isCalledReloadData = false
  
  // MARK: - Public Methods
  
  override func reloadData() {
    super.reloadData()
    isCalledReloadData = true
  }
}
