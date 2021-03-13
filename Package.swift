// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UISliderView",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
          name: "UISliderView",
          targets: ["UISliderView"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
          name: "UISliderView",
          dependencies: [],
          path: "UISliderView"
        ),
        .testTarget(
          name: "UISliderViewTests",
          dependencies: ["UISliderView"],
          path: "UISliderViewTests"
        )
    ]
)
