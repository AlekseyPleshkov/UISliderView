# 📦 UISliderView

Easy and customizable Swift image slider with lazy loading images and full screen viewer

## 🛠 Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

For integrate `UISliderView` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
pod 'UISliderView', '~> 0.0.1'
end
```

Then, run the following terminal command in project directory:

```bash
$ pod install
```

Import package in you project

```
import UISliderView
```

## 💻 How to use

### Simple usage

Set `UISliderView` class to custom class for empty view or create `UISliderView` class programmably.

```swift
@IBOutlet weak var sliderView: UISliderView!
// or
let sliderView = UISliderView()
```

Set list of image urls to `sliderView` and run `reloadData()` method for create/reload slides with images

```swift
sliderView.images = [
  URL(string: "https://source.unsplash.com/1024x1024")!,
  URL(string: "https://source.unsplash.com/1024x1024")!,
  URL(string: "https://source.unsplash.com/1024x1024")!,
  URL(string: "https://source.unsplash.com/1024x1024")!
]
sliderView.reloadData()
```

It's done!

### Available configurations

#### Parameters:
```swift
/// UISliderView

/// The object that acts as the delegate of the slider view.
/// Notifies at main events
delegate: UISliderViewDelegate?

/// View controller for show full screen slider
/// Set this parameter to open slider in full screen
viewController: UIViewController?

/// List of image urls for loading and showing in sliders
images: [URL]

// Image content mode for slide
imageContentMode: UIView.ContentMode = .scaleAspectFill
/// Activity indicator color (while the image is loading)
activityIndicatorColor: UIColor = .black
/// Activity indicator style (while the image is loading)
activityIndicatorStyle: UIActivityIndicatorView.Style?
/// Page indicator color
pageIndicatorColor: UIColor?
/// Current page indicator color
pageCurrentIndicatorColor: UIColor?

/// Image content mode for full screen slide
fullScreenImageContentMode: UIView.ContentMode = .scaleAspectFill
///  Activity indicator color (while the image is loading) for full screen slide
fullScreenActivityIndicatorColor: UIColor = .white
/// Activity indicator style (while the image is loading) for full screen slide
fullScreenActivityIndicatorStyle: UIActivityIndicatorView.Style?
/// Image for back button in full screen mode
/// Automatically hidden button if image not set
fullScreenBackButtonImage: UIImage?

/// Shows pageControl indicator
isShowPageControl: Bool = true
```

#### Methods:
```swift
/// Reloads slides by list of url images
/// Call this method after set list of urls to image parameter
reloadData()
```

### Delegate

```swift
/// UISliderViewDelegate

/// Tells the delegate that the slide did change
sliderView(_ sliderView: UISliderView, didChangeSlideAt index: Int)

/// Tells the delegate that the full screen view did change visible state
sliderView(_ sliderView: UISliderView, didChangeFullScreenVisible isVisible: Bool)
```

## 🚧 Requirements

- Swift 5.0
- XCode 10
- iOS 11 or later

## 🖖 About Me

* Aleksey Pleshkov
* Email: [im@alekseypleshkov.ru](mailto:im@alekseypleshkov.ru)
* Website: [alekseypleshkov.ru](https://alekseypleshkov.ru)

## ©️ License

`UISliderView` is released under the MIT license. In short, it's royalty-free but you must keep the copyright notice in your code or software distribution.
