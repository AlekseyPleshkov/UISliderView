//
//  UISliderView.swift
//  UISliderView
//
//  Created by Aleksey Pleshkov on 26.01.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit

public protocol UISliderViewDelegate: class {
  /// Tells the delegate that the slide did change
  func sliderView(_ sliderView: UISliderView, didChangeSlideAt index: Int)
  /// Tells the delegate that the full screen view did change visible state
  func sliderView(_ sliderView: UISliderView, didChangeFullScreenVisible isVisible: Bool)
}

extension UISliderViewDelegate {
  func sliderView(_ sliderView: UISliderView, didChangeSlideAt index: Int) {}
  func sliderView(_ sliderView: UISliderView, didChangeFullScreenVisible isVisible: Bool) {}
}

open class UISliderView: UIView {
  
  // MARK: - Public Properties
  
  /// The object that acts as the delegate of the slider view.
  /// Notifies at main events
  public weak var delegate: UISliderViewDelegate?
  
  /// View controller for show full screen slider
  /// Set this parameter to open slider in full screen
  public weak var viewController: UIViewController?
  
  /// List of image urls for loading and showing in sliders
  public var images: [URL] = []
  
  // Image content mode for slide
  public var imageContentMode = UIView.ContentMode.scaleAspectFill
  /// Activity indicator color (while the image is loading)
  public var activityIndicatorColor = UIColor.black
  /// Activity indicator style (while the image is loading)
  public var activityIndicatorStyle: UIActivityIndicatorView.Style?
  /// Page indicator color
  public var pageIndicatorColor: UIColor?
  /// Current page indicator color
  public var pageCurrentIndicatorColor: UIColor?
  
  /// Image content mode for full screen slide
  public var fullScreenImageContentMode = UIView.ContentMode.scaleAspectFill
  ///  Activity indicator color (while the image is loading) for full screen slide
  public var fullScreenActivityIndicatorColor = UIColor.white
  /// Activity indicator style (while the image is loading) for full screen slide
  public var fullScreenActivityIndicatorStyle: UIActivityIndicatorView.Style?
  /// Image for back button in full screen mode
  /// Automatically hidden button if image not set
  public var fullScreenBackButtonImage: UIImage?

  /// Shows pageControl indicator
  public var isShowPageControl = true {
    didSet {
      pageControl.isHidden = !isShowPageControl
    }
  }
    
  // MARK: - Internal Properties
  
  var loadedImages: [Int: UIImage] = [:]
  var indexActiveSlide = 0

  var activeCell: UISliderCollectionViewCell? {
    let indexPath = IndexPath(item: indexActiveSlide, section: 0)
    return collectionView.cellForItem(at: indexPath) as? UISliderCollectionViewCell
  }
  
  var collectionViewLayout: UICollectionViewFlowLayout!
  var collectionView: UICollectionView!
  var pageControl: UIPageControl!
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    configure()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  // MARK: - Public Methods
  
  /// Reloads slides by list of url images
  /// Call this method after set list of urls to image parameter
  ///
  /// # Example
  /// ```
  /// @IBOutlet weak var sliderView: UISliderView!
  /// ...
  /// sliderView.images = [...]
  /// sliderView.reloadData()
  /// ```
  open func reloadData() {
    let indexPath = IndexPath(item: self.indexActiveSlide, section: 0)
    let isShowPageControl = self.isShowPageControl ? images.count > 0 : false
    
    pageControl.isHidden = !isShowPageControl
    pageControl.numberOfPages = images.count
    pageControl.currentPage = indexActiveSlide
    pageControl.pageIndicatorTintColor = pageIndicatorColor
    pageControl.currentPageIndicatorTintColor = pageCurrentIndicatorColor
    
    collectionView.reloadData()
    collectionView.performBatchUpdates(nil) { [weak self] _ in
      self?.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self?.updateImage()
      }
    }
  }
  
  // MARK: - Private Methods
    
  private func configure() {
    configureView()
    configureConstraints()
  }
  
  private func configureView() {
    backgroundColor = .clear
    
    collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.scrollDirection = .horizontal
    collectionViewLayout.sectionInset = .zero
    collectionViewLayout.estimatedItemSize = .zero
    collectionViewLayout.minimumInteritemSpacing = 0
    collectionViewLayout.minimumLineSpacing = 0
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UISliderCollectionViewCell.self, forCellWithReuseIdentifier: "SliderCollectionViewCell")
    collectionView.backgroundColor = .clear
    collectionView.bounces = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.clipsToBounds = false
    
    pageControl = UIPageControl(frame: .zero)
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.isUserInteractionEnabled = false
    
    addSubview(collectionView)
    addSubview(pageControl)
  }
  
  private func configureConstraints() {
    let constraints = [
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      //
      pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
      pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func updateImage() {
    let index = indexActiveSlide
    
    let imageURL = images[index]
    let isLoaded = loadedImages.contains(where: { $0.key == index })
    
    guard !isLoaded else {
      return
    }
        
    fetchImage(url: imageURL) { [weak self] (image) in
      self?.activeCell?.updateImage(image: image)
      self?.loadedImages[index] = image
    }
  }
  
  private func fetchImage(url: URL, _ completion: @escaping (UIImage) -> Void) {
    DispatchQueue.global(qos: .utility).async {
      guard
        let loadedData = try? Data(contentsOf: url),
        let loadedImage = UIImage(data: loadedData)
        else { return }
              
      DispatchQueue.main.async {
        completion(loadedImage)
      }
    }
  }
  
  private func showFullScreenSlider() {
    guard let viewController = viewController else {
      return
    }
    
    let fullScreenSliderViewController = UIFullScreenSliderViewController()
    let fullScreenSliderView = UIFullScreenSliderView(
      viewController: fullScreenSliderViewController,
      backButtonImage: fullScreenBackButtonImage)
    
    fullScreenSliderViewController.attach(fullScreenSlider: fullScreenSliderView)
    fullScreenSliderViewController.modalPresentationStyle = .overFullScreen
    
    fullScreenSliderView.delegate = self
    
    fullScreenSliderView.imageContentMode = fullScreenImageContentMode
    fullScreenSliderView.activityIndicatorStyle = fullScreenActivityIndicatorStyle
    fullScreenSliderView.activityIndicatorColor = fullScreenActivityIndicatorColor
    
    fullScreenSliderView.images = images
    fullScreenSliderView.loadedImages = loadedImages
    fullScreenSliderView.indexActiveSlide = indexActiveSlide
    fullScreenSliderView.reloadData()
    
    viewController.present(fullScreenSliderViewController, animated: false)
  }
}

// MARK: - UICollectionViewDataSource

extension UISliderView: UICollectionViewDataSource {
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let loadedImage = loadedImages[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath)
    
    if let cell = cell as? UISliderCollectionViewCell {
      cell.configure(
        contentMode: imageContentMode,
        activityIndicatorColor: activityIndicatorColor,
        activityIndicatorStyle: activityIndicatorStyle)
      cell.updateImage(image: loadedImage)
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension UISliderView: UICollectionViewDelegate {
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    showFullScreenSlider()
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    indexActiveSlide = Int(scrollView.contentOffset.x / scrollView.frame.width)
    pageControl.currentPage = indexActiveSlide
    
    delegate?.sliderView(self, didChangeSlideAt: indexActiveSlide)
    
    updateImage()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UISliderView: UICollectionViewDelegateFlowLayout {
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.frame.size
  }
}

// MARK: - UIFullScreenSliderViewDelegate

extension UISliderView: UIFullScreenSliderViewDelegate {
  
  func fullScreenSliderView(_ fullScreenSliderView: UIFullScreenSliderView, didChangeVisible isVisible: Bool) {
    delegate?.sliderView(self, didChangeFullScreenVisible: isVisible)
  }
}
