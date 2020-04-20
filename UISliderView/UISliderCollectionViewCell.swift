//
//  UISliderCollectionViewCell.swift
//  UISliderView
//
//  Created by Aleksey Pleshkov on 26.01.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit

final class UISliderCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Internal Properties
  
  private(set) var imageView: UIImageView!
    
  // MARK: - Private Properties
  
  private var activityIndicatorView: UIActivityIndicatorView!
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  // MARK: - Internal Methods
  
  func configure(
    contentMode: UIView.ContentMode,
    activityIndicatorColor: UIColor,
    activityIndicatorStyle: UIActivityIndicatorView.Style?) {
    
    imageView.contentMode = contentMode
    activityIndicatorView.color = activityIndicatorColor
    
    if let activityIndicatorStyle = activityIndicatorStyle {
      activityIndicatorView.style = activityIndicatorStyle
    }
  }
  
  func updateImage(image: UIImage?) {
    let isEmptyImage = image == nil
    
    imageView.image = image
    isEmptyImage ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
  }
  
  func resetImageByViewCenter() {
    let updatedCenterX = center.x - frame.minX
    let updatedCenterY = center.y - frame.minY
    
    imageView.center = CGPoint(x: updatedCenterX, y: updatedCenterY)
  }
    
  // MARK: - Private Methods
  
  private func configure() {
    configureView()
    configureConstraints()
  }
  
  private func configureView() {
    clipsToBounds = false
    backgroundColor = .clear
    
    imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.color = .black
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.startAnimating()
    
    addSubview(imageView)
    addSubview(activityIndicatorView)
  }
  
  private func configureConstraints() {
    let constraints = [
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      //
      activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
