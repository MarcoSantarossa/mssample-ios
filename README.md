# MS Sample iOS app 📱

![Bitrise master](https://app.bitrise.io/app/3831ffc3a6ccebbf/status.svg?token=lNr1vIk_qeG4911v9YKmOA&branch=master)
![Swift version](https://img.shields.io/badge/Swift-5.0-F16D39.svg?style=flat)
![Platform](https://img.shields.io/badge/Platform-iOS-blue)

mssample-ios is an iOS app showcase built using [TDD](https://en.wikipedia.org/wiki/Test-driven_development) and [DDD](https://en.wikipedia.org/wiki/Domain-driven_design).

I'm not going to introduce anything new to the community but just put together all the pieces of the puzzle and apply the concept to an iOS application.

## Content 📚

* [Requirements](#requirements)
* [Features](#features)
  * [Album](#album)
* [Modularization](#modularization)
* [Architecture](./doc/Architecture.md)
* [License](#license)

## Requirements

* iOS 11.0+
* Xcode 10.2+
* Swift 5

You mush open **MSSampleiOS.xcworkspace**—which includes all the modules.

## Features

### Album

![photo-collection](./.github/images/photo-collection-1.jpg)
![photo-details](./.github/images/photo-details-1.jpg)

## Modularization

![Modularization](./.github/images/Modularization-1.jpg)

### App

It's the main project of the app and contains the skeleton of our iOS app which orchestrates all the modules.

### Core (+Mock)

The module `Core` provides the main functionalities of the app which must be used by all the vertical modules.
We have also a `CoreMock` to contain the [test doubles](https://marcosantadev.com/test-doubles-swift/) classes of `Core`.

### Album (Vertical module)

The module `Album` is a vertical module and provides the implementation for the feature photo collection and photo details views. It uses `Core` for main functionalities like `UIKit` extensions and networking.

Each module should expose a public router to allow the app to orchestrate the routing.

## License

mssample-ios is released under the MIT license. [See LICENSE](LICENSE) for details.
