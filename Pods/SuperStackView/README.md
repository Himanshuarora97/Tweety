# SuperStackView 📚

A feature rich version of UIStackView, with simple and powerful API.

# Intro

SuperStackView allows you to use instead of UIStackView, inspire from AloeStackView.

### Features

- Allows you to add dynamic spacing b/w views

    UIStackView doesn't allow to add the variable spacing with different views.

    UIStackView spacing property add spacing to all the views.

    iOS 11 added the support of dynamic spacing as stackView.setCustomSpacing(10.0, after: firstView) but it's not that flexible and only support line spacing b/w views.

- Allows you to set alignment (top, bottom and center) to separate views

    UIStackView alignment property applied to all the views, with SuperStackView you can set the alignment to any view.

- Built in separator view support
- Support all the properties of UIStackView

### How it works?

SuperStackView wrap the views before adding the view to stack along with optional separator.

This allows to change the content inset of any view which acts as subview.

## **System Requirements**

- Deployment target iOS 9.0+
- Xcode 10.0+
- Swift 4.0+

## **Installation**

`SuperStackView` is available through [CocoaPods](https://cocoapods.org/), to install it simply add the following line to your Podfile:

pod "SuperStackView"
