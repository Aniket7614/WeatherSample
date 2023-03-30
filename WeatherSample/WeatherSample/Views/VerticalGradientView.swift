//
//  VerticalGradientView.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 30/03/23.
//

import UIKit

@IBDesignable class VerticalGradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.red {
        didSet {
            setGradient()
        }
    }
    @IBInspectable var bottomColor: UIColor = UIColor.blue {
        didSet {
            setGradient()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient()
    }

    private func setGradient() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1)
    }
}
