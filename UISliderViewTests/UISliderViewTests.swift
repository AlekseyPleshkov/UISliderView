//
//  UISliderViewTests.swift
//  UISliderViewTests
//
//  Created by Aleksey Pleshkov on 26.01.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import XCTest
@testable import UISliderView

final class UISliderViewTests: XCTestCase {
  
  // MARK: - Private Properties
  
  private var sut: UISliderView!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
        
    sut = UISliderView()
  }
  
  override func tearDown() {
    sut = nil
    
    super.tearDown()
  }
  
  // MARK: - Init slide view
  
  func testInitSliderView() {
    // Given
    let collectionViewLayout = UICollectionViewLayout()
    let collectionViewSpy = UICollectionViewSpy(frame: .zero, collectionViewLayout: collectionViewLayout)
    let images = [
      URL(string: "https://source.unsplash.com/1024x1024")!,
      URL(string: "https://source.unsplash.com/1024x1024")!,
      URL(string: "https://source.unsplash.com/1024x1024")!,
      URL(string: "https://source.unsplash.com/1024x1024")!
    ]
    
    // When
    sut.collectionView = collectionViewSpy
    sut.collectionView.dataSource = sut
    sut.images = images
    sut.reloadData()
    
    // Then
    XCTAssert(collectionViewSpy.isCalledReloadData)
    XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), images.count)
    XCTAssertEqual(sut.pageControl.numberOfPages, images.count)
    XCTAssertFalse(sut.pageControl.isHidden)
  }
  
  func testHidePageControl() {
    // Given
    let images = [
      URL(string: "https://source.unsplash.com/1024x1024")!
    ]
    
    // When
    sut.images = images
    sut.reloadData()
    
    // Then
    XCTAssertTrue(sut.pageControl.isHidden)
  }
}
