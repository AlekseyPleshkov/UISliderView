//
//  UIFullScreenSliderViewTests.swift
//  UISliderViewTests
//
//  Created by Aleksey Pleshkov on 03.02.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import XCTest
@testable import UISliderView

final class UIFullScreenSliderViewTests: XCTestCase {
  
  // MARK: - Private Properties
  
  private var sut: UIFullScreenSliderView!
  private var viewController: UIViewController!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    
    viewController = UIViewController()
    sut = UIFullScreenSliderView(viewController: viewController, backButtonImage: nil)
  }
  
  override func tearDown() {
    viewController = nil
    sut = nil
    
    super.tearDown()
  }
  
  // MARK: - Init full screen mode slide view
  
  func testInitSliderView() {
    // Given
    let collectionViewLayout = sut.sliderView.collectionView.collectionViewLayout
    let collectionViewSpy = UICollectionViewSpy(frame: .zero, collectionViewLayout: collectionViewLayout)
    let images = [
      URL(string: "https://source.unsplash.com/1024x1024")!,
      URL(string: "https://source.unsplash.com/1024x1024")!,
      URL(string: "https://source.unsplash.com/1024x1024")!,
      URL(string: "https://source.unsplash.com/1024x1024")!
    ]
    
    // When
    sut.sliderView.collectionView = collectionViewSpy
    sut.sliderView.collectionView.dataSource = sut.sliderView
    
    sut.images = images
    sut.reloadData()
    
    // Then
    XCTAssert(collectionViewSpy.isCalledReloadData)
    XCTAssertEqual(sut.sliderView.collectionView.numberOfItems(inSection: 0), images.count)
    
    XCTAssertEqual(sut.images.count, images.count)
    XCTAssertEqual(sut.sliderView.images.count, images.count)
    
    XCTAssertEqual(sut.pageControl.numberOfPages, images.count)
    XCTAssertFalse(sut.pageControl.isHidden)
    XCTAssertTrue(sut.sliderView.pageControl.isHidden)
  }
}
