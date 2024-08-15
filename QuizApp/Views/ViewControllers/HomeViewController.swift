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
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    var countdownTimer: Timer?
    let endTime = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 19, hour: 23, minute: 59))!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           applyGradientToTopView()
           roundTopCornersOfBottomView()
           startTimer()
       }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        highScore()
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
    
    func highScore(){
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
              highScoreLabel.text = "\(highScore)"
    }
    
    func startTimer() {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        }

        @objc func updateCountdown() {
            let now = Date()
            let timeInterval = endTime.timeIntervalSince(now)
            
            if timeInterval > 0 {
                let hours = Int(timeInterval) / 3600
                let minutes = (Int(timeInterval) % 3600) / 60
                let seconds = Int(timeInterval) % 60

                hourLabel.text = String(format: "%02d", hours)
                minuteLabel.text = String(format: "%02d", minutes)
                secondsLabel.text = String(format: "%02d", seconds)
            } else {
                countdownTimer?.invalidate()
                hourLabel.text = "00"
                minuteLabel.text = "00"
                secondsLabel.text = "00"
            }
        }
    
    
    @IBAction func playQuizButton(_ sender: Any) {
        if let VC = storyboard!.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController {
                VC.modalPresentationStyle = .overCurrentContext
                VC.modalTransitionStyle = .crossDissolve
                VC.delegate = self // Set the delegate
                present(VC, animated: true, completion: nil)
            }
        
    }
    
    func navigateToQuestionAnswerVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let questionAnswerVC = storyboard.instantiateViewController(withIdentifier: "QuestionAnswerVC") as? QuestionAnswerViewController {
            self.navigationController?.pushViewController(questionAnswerVC, animated: true)
        }
    }
    
    }
