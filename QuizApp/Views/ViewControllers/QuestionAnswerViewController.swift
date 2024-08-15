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
    
    private var viewModel = QuestionAnswerViewModel()
    private var selectedAnswerKey: String? = nil
    private var correctAnswerKey: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupBackgroundGradient()
        setupCustomBackButton()
        
        viewModel.fetchQuestions { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.hasQuestions() ?? false {
                    self?.updateUI()
                } else {
                    print("No questions available.")
                }
            }
        }
        
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
        var remainingTime = 180
        
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
    
    private func updateUI() {
        guard let question = viewModel.currentQuestion else {
            print("No current question available.")
            return
        }
        
        questionNumberLabel.text = viewModel.getQuestionNumber()
        scoreLabel.text = "Score: \(viewModel.getScore() ?? 0)"
        questionLabel.text = question.question
        
        viewModel.getQuestionImage { [weak self] image in
            DispatchQueue.main.async {
                if image == nil{
                    self?.questionImage.image = UIImage(named: "JRF Card")
                }else{
                    self?.questionImage.image = image
                }
            }
        }
        
        correctAnswerKey = question.correctAnswer  // Store the correct answer key
        
        optionsTableView.reloadData()
        
        for i in 0..<optionsTableView.numberOfRows(inSection: 0) {
            if let cell = optionsTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? OptionTableViewCell {
                cell.resetState()
            }
        }
        
    }
    
    private func navigateToNextQuestionOrFinish() {
        if let _ = viewModel.getNextQuestion() {
            selectedAnswerKey = nil
            optionsTableView.allowsSelection = true
            updateUI()
        } else {
            print("End of quiz")
        }
    }
    @objc private func moveToNextQuestion() {
        navigateToNextQuestionOrFinish()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        navigateToNextQuestionOrFinish()
    }
}

extension QuestionAnswerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.currentQuestion?.answers.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as? OptionTableViewCell else {
                return UITableViewCell()
            }
            
            cell.resetState()
            
            if let answers = viewModel.currentQuestion?.answers {
                let answerKey = Array(answers.keys.sorted())[indexPath.row]
                let answerText = answers[answerKey] ?? ""
                cell.optionLabel.text = "\(answerKey). \(answerText)"
                
                if answerKey == correctAnswerKey {
                    cell.correctAnswerKey = answerKey  // Store the correct answer key in the cell
                }
            }
            
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let answers = viewModel.currentQuestion?.answers else { return }
            
            let answerKey = Array(answers.keys.sorted())[indexPath.row]
            selectedAnswerKey = answerKey
            
            let isCorrect = viewModel.isAnswerCorrect(selectedKey: answerKey)
            
            if let cell = tableView.cellForRow(at: indexPath) as? OptionTableViewCell {
                cell.setSelectedState(isCorrect: isCorrect)
            }
            
            if !isCorrect {
                // Highlight the correct answer if the wrong one was selected
                if let correctIndex = answers.keys.sorted().firstIndex(of: correctAnswerKey ?? "") {
                    if let correctCell = tableView.cellForRow(at: IndexPath(row: correctIndex, section: 0)) as? OptionTableViewCell {
                        correctCell.highlightAsCorrect()
                    }
                }
            }
            
            tableView.allowsSelection = false
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(moveToNextQuestion), userInfo: nil, repeats: false)

        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

