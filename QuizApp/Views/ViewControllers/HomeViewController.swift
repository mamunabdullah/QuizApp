//
//  HomeViewController.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           applyGradientToTopView()
           roundTopCornersOfBottomView()
       }

       func applyGradientToTopView() {
           GradientHelper.applyGradient(to: topView, colors: [
               UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1.0).cgColor,
               UIColor(red: 230/255, green: 101/255, blue: 20/255, alpha: 1.0).cgColor
           ])
       }

       func roundTopCornersOfBottomView() {
           let path = UIBezierPath(roundedRect: bottomView.bounds,
                                   byRoundingCorners: [.topLeft, .topRight],
                                   cornerRadii: CGSize(width: 30, height: 30))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           bottomView.layer.mask = mask
       }
    
    @IBAction func playQuizButton(_ sender: Any) {
        
    }
    
    }
