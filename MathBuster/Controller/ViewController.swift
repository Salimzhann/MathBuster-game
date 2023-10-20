//
//  ViewController.swift
//  MathBuster
//
//  Created by Manas Salimzhan on 09.10.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var selectControl: UISegmentedControl!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var loadProg: UIProgressView!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    let userScoreKey: String = "userScore"
    var timer: Timer!
    var countdown = 30
    var result: Double?
    var score: Int = 0
    var ranges = [0...9,10...99,100...999]
    var coins: [Int] = [1,2,3]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateProblem()
    }
    
    func setupUI(){
        BackView.layer.cornerRadius = 5
        answerField.keyboardType = .decimalPad
    }
    
    func generateProblem(){
        let index: Int = selectControl.selectedSegmentIndex
        let range = ranges[index]
        var st = range.lowerBound
        var end = range.upperBound
        let firstDigit = Int.random(in: range)
        let ArithmeticOperation: String = ["+","-","*","/"].randomElement()!
        
        if ArithmeticOperation == "-" {
            end = firstDigit
        }else if ArithmeticOperation == "/" && index == 0{
            st = 1
        }
        let secondDigit = Int.random(in: st...end)
        
        
        taskLabel.text = "\(firstDigit) \(ArithmeticOperation) \(secondDigit) = "
        
        switch ArithmeticOperation{
        case "+":
            result = Double(firstDigit+secondDigit)
        case "-":
            result = Double(firstDigit-secondDigit)
        case "*":
            result = Double(firstDigit*secondDigit)
        case "/":
            result = Double(firstDigit)/Double(secondDigit)
        default:
            result = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduleTimer()
    }
    
    func scheduleTimer() {
        countdown = 30
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimerUI), userInfo: nil, repeats: true)
    }
    @objc
    func UpdateTimerUI(){
        countdown -= 1
        if countdown >= 10 {
            timerLabel.text = "00:\(countdown)"
        }else {
            timerLabel.text = "00:0\(countdown)"
        }
       
        loadProg.progress = Float(countdown)/30
        if countdown <= 0 {
           finishGame()
        }
    }
    @IBAction func SubmitPressed(_ sender: Any) {
        guard let text = answerField.text else{
            return
        }
        guard !text.isEmpty else{
            return
        }
        guard let result = Double(text) else{
            return
        }
        if result == self.result {
            let range = selectControl.selectedSegmentIndex
            score += coins[range]
            scoreLabel.text = "Your score:  \(score)"
        }else {
            
        }
        generateProblem()
        answerField.text = nil
        
    }
    @IBAction func RestartPressed(_ sender: Any) {
        restart()
    }
    func restart () {
        answerField.isEnabled = true
        SubmitButton.isEnabled = true
        generateProblem()
        answerField.text = nil
        scheduleTimer()
        score = 0
        scoreLabel.text = "Your score: \(score)"
    }

    @IBAction func chosenIndex(_ sender: UISegmentedControl) {
        restart()
    }
    
    func finishGame(){
        timer.invalidate()
        answerField.isEnabled = false
        SubmitButton.isEnabled = false
        askName()
    }
    
    func askName(){
        let alertController = UIAlertController(title: "Game is Over!", message: "Save your score: \(score)", preferredStyle: .alert)
        alertController.addTextField() { temp in
            temp.placeholder = "Enter your name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first else{
                return
            }
            guard let text = textField.text , !text.isEmpty else{
                return
            }
            self.saveScore(name: text)
            
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func saveScore(name: String){
        let userScore:[String:Any] = ["name": name, "score": score]
        let userScoreArr: [[String: Any]] = getUserScoreArray() + [userScore]
        let userdef = UserDefaults.standard
        userdef.set(userScoreArr, forKey: ViewController().userScoreKey)
    }
    func getUserScoreArray () -> [[String:Any]] {
        let userdef = UserDefaults.standard
        let array = userdef.array(forKey: ViewController().userScoreKey) as? [[String:Any]]
        return array ?? []
    }
}


