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
    
    private var grayBackgroundView: UIView!
    private var redLoaderView: UIView!
    private var widthConstraint: NSLayoutConstraint!
    private var totalTime: TimeInterval = 10.0
    private var elapsedTime: TimeInterval = 0.0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        setupBackgroundGradient()
        setupCustomBackButton()
        setupTimeLoaderView()
        startLoaderAnimation()
        
        viewModel.fetchQuestions { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.hasQuestions() ?? false {
                    self?.updateUI()
                    self?.resetAndStartTimeLoader()
                } else {
                    print("No questions available.")
                }
            }
        }
        
    }
    
    //Time Loader Start
    private func setupGrayBackgroundView() {
        // Create the gray background view with corner radius
        grayBackgroundView = UIView()
        grayBackgroundView.backgroundColor = .gray
        grayBackgroundView.layer.cornerRadius = 6
        grayBackgroundView.clipsToBounds = true
        grayBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        timerSubView.addSubview(grayBackgroundView)
        
        // Set constraints for gray background view
        NSLayoutConstraint.activate([
            grayBackgroundView.leadingAnchor.constraint(equalTo: timerSubView.leadingAnchor, constant: 40),
            grayBackgroundView.trailingAnchor.constraint(equalTo: timerSubView.trailingAnchor, constant: -40),
            grayBackgroundView.topAnchor.constraint(equalTo: timerSubView.topAnchor),
            grayBackgroundView.bottomAnchor.constraint(equalTo: timerSubView.bottomAnchor)
        ])
    }

    private func setupTimeLoaderView() {
        // Initialize the gray background view
        grayBackgroundView = UIView()
        grayBackgroundView.backgroundColor = UIColor(rgb: 0xE3E6EA)
        grayBackgroundView.layer.cornerRadius = 6
        grayBackgroundView.clipsToBounds = true
        grayBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        timerSubView.addSubview(grayBackgroundView)

        // Set constraints for gray background view
        NSLayoutConstraint.activate([
            grayBackgroundView.leadingAnchor.constraint(equalTo: timerSubView.leadingAnchor, constant: 40),
            grayBackgroundView.trailingAnchor.constraint(equalTo: timerSubView.trailingAnchor, constant: -40),
            grayBackgroundView.topAnchor.constraint(equalTo: timerSubView.topAnchor),
            grayBackgroundView.bottomAnchor.constraint(equalTo: timerSubView.bottomAnchor)
        ])

        // Initialize the red loader view
        redLoaderView = UIView()
        redLoaderView.backgroundColor = UIColor(rgb: 0xBE1E2D)
        redLoaderView.layer.cornerRadius = 6
        redLoaderView.clipsToBounds = true
        redLoaderView.translatesAutoresizingMaskIntoConstraints = false
        grayBackgroundView.addSubview(redLoaderView)

        // Set constraints for red loader view
        NSLayoutConstraint.activate([
            redLoaderView.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor),
            redLoaderView.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor),
            redLoaderView.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor)
        ])

        // Set the initial width constraint for the red loader view
        widthConstraint = redLoaderView.widthAnchor.constraint(equalToConstant: grayBackgroundView.frame.width)
        widthConstraint.isActive = true
    }
    @objc private func updateTimeLoader() {
        elapsedTime += 1.0
        let remainingTime = totalTime - elapsedTime
        let newWidth = grayBackgroundView.frame.width * CGFloat(remainingTime / totalTime)
        
        UIView.animate(withDuration: 1.0) {
            self.widthConstraint.constant = newWidth
            self.grayBackgroundView.layoutIfNeeded()
        }
        
        if elapsedTime >= totalTime {
            timer?.invalidate()
            moveToNextQuestion()
        }
    }

    private func resetAndStartTimeLoader() {
        // Reset the elapsed time and width constraint
        elapsedTime = 0.0
        
        // Set the red loader's width back to full width of the gray background view
        widthConstraint.constant = grayBackgroundView.frame.width
        grayBackgroundView.layoutIfNeeded()
        
        // Start the loader animation
        startLoaderAnimation()
    }


    private func startLoaderAnimation() {
        elapsedTime = 0.0
        timer?.invalidate()  // Invalidate any existing timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLoader), userInfo: nil, repeats: true)
    }
    //Time Loader End
    
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
        
        resetAndStartTimeLoader()
        
    }
    
    private func navigateToNextQuestionOrFinish() {
        if let _ = viewModel.getNextQuestion() {
            selectedAnswerKey = nil
            optionsTableView.allowsSelection = true
            updateUI()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let VC = storyboard.instantiateViewController(withIdentifier: "CongratsViewController") as? CongratsViewController {
                VC.modalPresentationStyle = .overCurrentContext
                VC.modalTransitionStyle = .crossDissolve
                
                VC.correctAnswerCount = viewModel.getCorrectAnswerCount()
                VC.totalQuestions = viewModel.totalQuestions
                VC.totalScore = viewModel.getTotalScore()
                
                present(VC, animated: true, completion: nil)
            }
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

