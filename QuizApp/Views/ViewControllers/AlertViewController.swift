//
//  AlertViewController.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import UIKit

protocol AlertViewControllerDelegate: AnyObject {
    func didTapYesButton()
}

class AlertViewController: UIViewController {

    weak var delegate: AlertViewControllerDelegate? // Delegate property

       override func viewDidLoad() {
           super.viewDidLoad()
       }
    
    @IBAction func yesButton(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
                    self?.delegate?.didTapYesButton() // Notify the delegate
                }
    }
    
    @IBAction func noButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension HomeViewController: AlertViewControllerDelegate {
    func didTapYesButton() {
        navigateToQuestionAnswerVC()
    }
}
