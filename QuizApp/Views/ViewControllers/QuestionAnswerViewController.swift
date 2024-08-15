//
//  QuestionAnswerViewController.swift
//  QuizApp
//
//  Created by Abdullah Al Mamun on 15/8/24.
//

import UIKit

class QuestionAnswerViewController: UIViewController {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionImage: CustomImage!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timerSubView: UIView!
    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupBackgroundGradient()
        setupCustomBackButton()
        
    }
    
    private func setupBackgroundGradient() {
        GradientHelper.applyGradient(to: self.view, colors: [
            UIColor(red: 190/255, green: 30/255, blue: 45/255, alpha: 1).cgColor,
            UIColor(red: 230/255, green: 101/255, blue: 20/255, alpha: 1).cgColor
        ])
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        // Create a container view for the clock and label
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 70, height: 15)
        
        // Create the clock image view
        let clockImageView = UIImageView(image: UIImage(named: "clock"))
        clockImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        containerView.addSubview(clockImageView)
        
        // Create the timer label
        let timerLabel = UILabel()
        timerLabel.frame = CGRect(x: 19, y: 0, width: 50, height: 15)
        timerLabel.font = UIFont.systemFont(ofSize: 14)
        timerLabel.textColor = .white
        containerView.addSubview(timerLabel)
        
        // Set as the title view of the navigation bar
        self.navigationItem.titleView = containerView
        
        // Start the timer
        startTimer(label: timerLabel)
    }
    
    private func startTimer(label: UILabel) {
        var remainingTime = 300 // 5 minutes in seconds
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
                let minutes = remainingTime / 60
                let seconds = remainingTime % 60
                label.text = String(format: "%02d:%02d", minutes, seconds)
            } else {
                timer.invalidate()
            }
        }
    }
    
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButton(_ sender: Any) {
       
    }
}

extension QuestionAnswerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell
    
        cell?.optionLabel.text = "A"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

