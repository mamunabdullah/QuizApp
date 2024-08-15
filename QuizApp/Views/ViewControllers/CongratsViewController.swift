//
//  CongratsViewController.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import UIKit

class CongratsViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var correctAnswerCount: Int = 0
       var totalQuestions: Int = 0
       var totalScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentHighScore = UserDefaults.standard.integer(forKey: "highScore")
               if totalScore > currentHighScore {
                   UserDefaults.standard.set(totalScore, forKey: "highScore")
                   UserDefaults.standard.synchronize()
               }
        let resultMessage = "You have completed your Quiz. Correct answers: \(correctAnswerCount)/\(totalQuestions), and you earned \(totalScore) coins."
        print(resultMessage)
        messageLabel.text = resultMessage
       
    }
    

    @IBAction func goToHome(_ sender: Any) {
        let rootViewController = self.view.window?.rootViewController as? UINavigationController

                rootViewController?.setViewControllers([rootViewController!.viewControllers.first!],
                animated: false)

                rootViewController?.dismiss(animated: true, completion: nil)

    }
    
}

