//
//  StartRoutineViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 18/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class StartRoutineViewController: UIViewController,
    UIPickerViewDelegate, UIPickerViewDataSource,
    UITableViewDelegate, UITableViewDataSource {
    
    var routineAux: Routine!
    @IBOutlet weak var lbInstructions: UILabel!
    @IBOutlet weak var lbSets: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var pvTimer: UIPickerView!
    @IBOutlet weak var swAutoRestart: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var seconds, selectedSeconds: Int!
    var timer = Timer()
    
    var routineExercises: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = routineAux.name
        lbInstructions.attributedText = styleLabels(myString: "Instructions: \(routineAux.instructions!)", lenght: 13)
        lbSets.attributedText = styleLabels(myString: "Sets: \(routineAux.routineSets!)", lenght: 5)
        
        routineExercises = routineAux.exercises
        tableView.register(UINib(nibName: "ExerciseCellTableViewCell", bundle: nil), forCellReuseIdentifier: "exerciseCell")
    }
    
    // Alert to ask for at least
    func sendAlert(text: String) {
        let alert = UIAlertController(title: "Hey!", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)
    }
    
    //MARK: - Timer management and actions
    @IBAction func startButtonTapped(_ sender: UIButton) {
        switch startButton.tag {
        case 0:
            getSeconds()
            if selectedSeconds == 0 {
                sendAlert(text: "Set some time first")
                break
            }
            runTimer()
            startButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            startButton.tag = 1
            pvTimer.isUserInteractionEnabled = false
            break
        case 1:
            timer.invalidate()
            startButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            startButton.tag = 2
            break
        case 2:
            runTimer()
            startButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            startButton.tag = 1
            break
        default:
            break
        }
    }
    
    @IBAction func btnResetTapped(_ sender: UIButton) {
        timer.invalidate()
        self.seconds = self.selectedSeconds
        setpickerTimer(time: TimeInterval(selectedSeconds))
        startButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        startButton.tag = 0
        pvTimer.isUserInteractionEnabled = true
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: (#selector(updateTimer)),
            userInfo: nil,
            repeats: true
        )
    }
    
    func autoRestartTimer () {
        self.seconds = self.selectedSeconds
        setpickerTimer(time: TimeInterval(selectedSeconds))
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            if swAutoRestart.isOn {
                autoRestartTimer()
            } else {
                timer.invalidate()
                self.seconds = self.selectedSeconds
                setpickerTimer(time: TimeInterval(selectedSeconds))
                sendAlert(text: "Time is up!")
                startButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                startButton.tag = 0
                pvTimer.isUserInteractionEnabled = true
            }
        }
        else {
            seconds -= 1
            setpickerTimer(time: TimeInterval(seconds))
        }
    }
    
    func setpickerTimer(time:TimeInterval) {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        pvTimer.selectRow(hours, inComponent: 0, animated: true)
        pvTimer.selectRow(minutes, inComponent: 1, animated: true)
        pvTimer.selectRow(seconds, inComponent: 2, animated: true)
    }
    
    func getSeconds() {
        let hours = pvTimer.selectedRow(inComponent: 0)
        let minutes = pvTimer.selectedRow(inComponent: 1)
        let seconds = pvTimer.selectedRow(inComponent: 2)
        self.seconds = hours * 3600 + minutes * 60 + seconds
        self.selectedSeconds = self.seconds
    }
    
    // MARK: - Picker View Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    // MARK: - Methods for Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineAux.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCellTableViewCell
        cell.lbReps.text = String(routineExercises[indexPath.row].defRepetitions)
        cell.lbName.text = routineExercises[indexPath.row].name
        cell.lbType.text = routineExercises[indexPath.row].type
        
        return cell
    }
    
    // MARK: - Styles
    func styleLabels(myString: String, lenght: Int) -> NSMutableAttributedString {
        //Initialize the mutable string
        let myMutableString = NSMutableAttributedString(
            string: myString,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]
        )
        myMutableString.addAttribute(
            NSAttributedString.Key.font,
            value: UIFont.boldSystemFont(ofSize: 17.0),
            range: NSRange( location: 0, length: lenght)
        )
        return myMutableString
    }
}
