//
//  UIFullScreenSliderView.swift
//  UISliderView
//
//  Created by Aleksey Pleshkov on 26.01.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit

protocol UIFullScreenSliderViewDelegate: class {
  func fullScreenSliderView(_ fullScreenSliderView: UIFullScreenSliderView, didChangeVisible isVisible: Bool)
}

final class UIFullScreenSliderView: UIView {
  
  // MARK: - Internal Properties
  
  weak var delegate: UIFullScreenSliderViewDelegate?
  
  var images: [URL] = []
  var loadedImages: [Int: UIImage] = [:]
  var indexActiveSlide = 0
  
  var imageContentMode = UIView.ContentMode.scaleAspectFill
  var activityIndicatorColor = UIColor.white
  var activityIndicatorStyle: UIActivityIndicatorView.Style?
  
  var pageControl: UIPageControl!
  var sliderView: UISliderView!
  var backButton: UIButton!
  
  // MARK: - Private Properties
  
  private unowned let viewController: UIViewController
  private let backButtonImage: UIImage?
  
  private let maxOffsetToHide: CGFloat = 100
  private var activeScale: CGFloat = 1
  private let minScale: CGFloat = 1
  private let maxScale: CGFloat = 3
  
  // MARK: - Init
  
  public init(viewController: UIViewController, backButtonImage: UIImage?) {
    self.viewController = viewController
    self.backButtonImage = backButtonImage
    super.init(frame: .zero)
    configure()
  }
  
  required public init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Internal Methods
  
  func reloadData() {
    sliderView.imageContentMode = imageContentMode
    sliderView.activityIndicatorStyle = activityIndicatorStyle
    sliderView.activityIndicatorColor = activityIndicatorColor
    
    sliderView.images = images
    sliderView.loadedImages = loadedImages
    sliderView.indexActiveSlide = indexActiveSlide
    sliderView.reloadData()
    
    pageControl.numberOfPages = images.count
    pageControl.currentPage = indexActiveSlide
    pageControl.isHidden = images.count <= 1
  }
  
  // MARK: - Private Methods
  
  private func configure() {
    configureView()
    configureConstraints()
    configureGestures()
    
    // Dirty hack
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.show()
    }
  }
  
  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .black
    layer.opacity = 0
    
    pageControl = UIPageControl(frame: .zero)
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.isUserInteractionEnabled = false
    
    sliderView = UISliderView()
    sliderView.isShowPageControl = false
    sliderView.translatesAutoresizingMaskIntoConstraints = false
    sliderView.delegate = self
    
    backButton = UIButton()
    backButton.translatesAutoresizingMaskIntoConstraints = false
    
    if let backButtonImage = backButtonImage {
      backButton.setImage(backButtonImage, for: .normal)
      backButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    addSubview(pageControl)
    addSubview(sliderView)
    addSubview(backButton)
  }
  
  private func configureConstraints() {
    let sliderViewHeight = viewController.view.frame.width
    
    let constraints = [
      pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
      pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
      //
      sliderView.centerYAnchor.constraint(equalTo: centerYAnchor),
      sliderView.leadingAnchor.constraint(equalTo: leadingAnchor),
      sliderView.trailingAnchor.constraint(equalTo: trailingAnchor),
      sliderView.heightAnchor.constraint(equalToConstant: sliderViewHeight),
      //
      backButton.widthAnchor.constraint(equalToConstant: 41),
      backButton.heightAnchor.constraint(equalToConstant: 44),
      backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
      backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureGestures() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(actionPanGesture))
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(actionDoubleTapGesture))
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(actionPinchGesture))
    
    doubleTapGesture.numberOfTapsRequired = 2
    
    addGestureRecognizer(doubleTapGesture)
    addGestureRecognizer(panGesture)
    addGestureRecognizer(pinchGesture)
  }
  
  private func moveView(by offsetY: CGFloat) {
    let percent = Float(maxOffsetToHide - abs(offsetY)) * 0.01
    let updatedPercent = percent < 0.1 ? 0.1 : percent
    let animations: () -> Void = { [unowned self] in
      self.layer.opacity = updatedPercent
      self.sliderView.transform = CGAffineTransform(translationX: 0, y: offsetY)
    }
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 1,
      options: [],
      animations: animations)
  }
  
  private func animateTransformCell(_ updatedTransform: CGAffineTransform, duration: Double = 0.3) {
    guard let activeCell = sliderView.activeCell else {
      return
    }
    
    let animations: () -> Void = {
      activeCell.imageView.transform = updatedTransform
      activeCell.resetImageByViewCenter()
    }
    
    UIView.animate(withDuration: duration, animations: animations)
  }
  
  private func show() {
    layer.opacity = 0
    layoutIfNeeded()
    
    UIView.animate(withDuration: 0.3) { [unowned self] in
      self.layer.opacity = 1
    }
    
    delegate?.fullScreenSliderView(self, didChangeVisible: true)
  }
  
  @objc private func hide() {
    let animations: () -> Void = { [unowned self] in
      self.layer.opacity = 0
    }
    
    let completion: (Bool) -> Void = { [unowned self] _ in
      self.viewController.dismiss(animated: false)
    }
    
    UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
    
    delegate?.fullScreenSliderView(self, didChangeVisible: false)
  }
}

// MARK: - Actions

extension UIFullScreenSliderView {
  
  @objc private func actionPanGesture(gesture: UIPanGestureRecognizer) {
    if activeScale == minScale {
      moveToHide(gesture: gesture)
    } else {
      moveSlide(gesture: gesture)
    }
  }
  
  @objc private func actionDoubleTapGesture(gesture: UITapGestureRecognizer) {
    if activeScale == minScale {
      activeScale = maxScale
      sliderView.isUserInteractionEnabled = false
      animateTransformCell(CGAffineTransform(scaleX: maxScale, y: maxScale))
    } else {
      activeScale = minScale
      sliderView.isUserInteractionEnabled = true
      animateTransformCell(CGAffineTransform(scaleX: minScale, y: minScale))
    }
  }
  
  @objc private func actionPinchGesture(gesture: UIPinchGestureRecognizer) {
    
    let updatedScale: CGFloat = {
      let scale = activeScale + gesture.velocity * 0.03
      
      if scale < minScale {
        return minScale
      }
      
      if scale > maxScale {
        return maxScale
      }
      
      return scale
    }()
    
    switch gesture.state {
    case .began:
      sliderView.isUserInteractionEnabled = false
    case .changed:
      activeScale = updatedScale
      animateTransformCell(CGAffineTransform(scaleX: updatedScale, y: updatedScale))
    case .ended:
      sliderView.isUserInteractionEnabled = activeScale == minScale
    default:
      break
    }
  }
  
  private func moveToHide(gesture: UIPanGestureRecognizer) {
    let velocity = gesture.velocity(in: self).y * 0.014
    let offsetY = sliderView.transform.ty + velocity
    let isMoveToHidden = abs(offsetY) > maxOffsetToHide
    
    switch gesture.state {
    case .changed:
      moveView(by: offsetY)
    case .ended:
      isMoveToHidden ? hide() : moveView(by: 0)
    default:
      break
    }
  }

  private func moveSlide(gesture: UIPanGestureRecognizer) {
    guard let activeCell = sliderView.activeCell else {
      return
    }

    let velocityX = gesture.velocity(in: self).x * 0.04
    let velocityY = gesture.velocity(in: self).y * 0.04
    
    let minOffsetX = activeCell.frame.width - activeCell.imageView.frame.width / 2
    let maxOffsetX = activeCell.imageView.frame.width / 2
    
    let topOffsetToSlider = (frame.height - sliderView.frame.height) / 2
    let initialOffsetY = activeCell.frame.height / 2
    let minOffsetY = topOffsetToSlider + sliderView.frame.height - activeCell.imageView.frame.height / 2
    let maxOffsetY = activeCell.imageView.frame.height / 2 - topOffsetToSlider
    
    let updatedCenterX: CGFloat = {
      let newValue = activeCell.imageView.center.x + velocityX

      if newValue < minOffsetX { return minOffsetX }
      if newValue > maxOffsetX { return maxOffsetX }

      return newValue
    }()
    
    let updatedCenterY: CGFloat = {
      let newValue = activeCell.imageView.center.y + velocityY

      if activeCell.imageView.frame.height <= frame.height {
        return initialOffsetY
      }
      
      if newValue < minOffsetY { return minOffsetY }
      if newValue > maxOffsetY { return maxOffsetY }

      return newValue
    }()
        
    switch gesture.state {
    case .changed:
      UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
        activeCell.imageView.center = CGPoint(x: updatedCenterX, y: updatedCenterY)
      })
    default:
      break
    }
  }
}

// MARK: - UISliderViewDelegate

extension UIFullScreenSliderView: UISliderViewDelegate {

  public func sliderView(_ sliderView: UISliderView, didChangeSlideAt index: Int) {
    pageControl.currentPage = index
  }
}
