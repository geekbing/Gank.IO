# ITDAvatarPlaceholder

[![CI Status](http://img.shields.io/travis/Igor Kurylenko/ITDAvatarPlaceholder.svg?style=flat)](https://travis-ci.org/Igor Kurylenko/ITDAvatarPlaceholder)
[![Version](https://img.shields.io/cocoapods/v/ITDAvatarPlaceholder.svg?style=flat)](http://cocoapods.org/pods/ITDAvatarPlaceholder)
[![License](https://img.shields.io/cocoapods/l/ITDAvatarPlaceholder.svg?style=flat)](http://cocoapods.org/pods/ITDAvatarPlaceholder)
[![Platform](https://img.shields.io/cocoapods/p/ITDAvatarPlaceholder.svg?style=flat)](http://cocoapods.org/pods/ITDAvatarPlaceholder)

Generates an avatar placeholder image with first letters of the provided full user name in the center.

<img src="https://cloud.githubusercontent.com/assets/5755524/14285529/94b80d50-fb54-11e5-89cc-371b3a419bd5.jpg" width="321px" alt="screenshot"/>

This library uses [Chameleon](https://github.com/ViccAlexander/Chameleon) (Flat Color Framework for iOS) for
a background color generation. Moreover a color of the background is computed from a hash of the provided 
user name.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To create the 256x256 placeholder image:

```swift
let avatarPlaceholderImage = UIImage.createAvatarPlaceholder(
        userFullName: "Erlich Bachman", placeholderSize: CGSizeMake(256, 256))
```


## Installation

ITDAvatarPlaceholder is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ITDAvatarPlaceholder"
```

## Author

Igor Kurylenko, igorkurylenko@gmail.com

## License

ITDAvatarPlaceholder is available under the MIT license. See the LICENSE file for more info.
