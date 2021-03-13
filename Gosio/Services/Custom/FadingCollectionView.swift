//
//  FadingCollectionView.swift
//  Gosio
//
//  Created by ANKIT YADAV on 13/03/21.
//

import UIKit
import Foundation

class FadingCollectionView : UICollectionView {
  var percent = Float(0.05)

  private let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
  private let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor

  override func awakeFromNib() {
    super.awakeFromNib()
    addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if object is FadingCollectionView && keyPath == "bounds" {
        initMask()
    }
  }

  deinit {
    removeObserver(self, forKeyPath:"bounds")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    updateMask()
  }

  func initMask() {
    let maskLayer = CAGradientLayer()
    maskLayer.locations = [0.0, NSNumber(value: percent), NSNumber(value:1 - percent), 1.0]
    maskLayer.bounds = CGRect(x:0, y:0, width:frame.size.width, height:frame.size.height)
    maskLayer.anchorPoint = CGPoint.zero
    self.layer.mask = maskLayer

    updateMask()
  }

  func updateMask() {
    let scrollView : UIScrollView = self

    var colors = [CGColor]()

    if scrollView.contentOffset.y <= -scrollView.contentInset.top { // top
        colors = [innerColor, innerColor, innerColor, outerColor]
    }
    else if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height { // bottom
        colors = [outerColor, innerColor, innerColor, innerColor]
    }
    else {
        colors = [outerColor, innerColor, innerColor, outerColor]
    }

    if let mask = scrollView.layer.mask as? CAGradientLayer {
        mask.colors = colors

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
        CATransaction.commit()
     }
  }
}
