//
//  ViewController.swift
//  WeatherSample
//
//  Created by Halcyon Tek on 29/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vwBg: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createGradientColorForBackgroundView()
    }
    
    
    func createGradientColorForBackgroundView(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        // Set the gradient colors
        gradientLayer.colors = [
            UIColor.blue.cgColor,
            UIColor.red.cgColor
        ]

        // Set the gradient direction (optional)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Add the gradient layer to the view's layer
        view.layer.addSublayer(gradientLayer)
    }


}

