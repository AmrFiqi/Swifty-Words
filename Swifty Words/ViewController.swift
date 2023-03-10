//
//  ViewController.swift
//  Swifty Words
//
//  Created by Amr El-Fiqi on 12/01/2023.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // Score label specs
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        // Clues label specs
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        // Answers label specs
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.text = "ANSWERS"
        answerLabel.textAlignment = .right
        answerLabel.numberOfLines = 0
        view.addSubview(answerLabel)
        
        // Current answer label specs
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap the letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // Submit answer button
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        // Clear Answer button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        // Creating buttons containers for the 20 buttons that will be created
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        
        // Create 20 buttons to put inside the button container
        let buttonWidth = 200
        let buttonHeight = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame  = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                letterButton.frame = frame
                buttonView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.75),
            buttonView.heightAnchor.constraint(equalToConstant: 320),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -25)
        
        ])
        buttonView.backgroundColor = .green
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
    }

    // Show the button the user tapped in currentAnswer and hide it from buttons list
    @objc func letterTapped (_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    // Clear the answer and show all the buttons
    @objc func clearTapped (_ sender: UIButton){
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    // Check if the answer is correct
    @objc func submitTapped (_ sender: UIButton){
        guard let answerText = currentAnswer.text else {return}

        if let solutionPosition = solutions.firstIndex(of: answerText){
            activatedButtons.removeAll()
            
            var splitAnswers =  answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!!", message: "Ready to move to the next level?!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes!!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
        else {
            let ac = UIAlertController(title: "Wrong!", message: "This is not a correct word", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try Again", style: .default))
            present(ac, animated: true)
            
        }
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: ".txt"){
            if let levelContent = try? String(contentsOf: levelFileURL){
                var lines = levelContent.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solution = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solution.count) letters\n"
                    solutions.append(solution)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count{
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp (_ action: UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
}

