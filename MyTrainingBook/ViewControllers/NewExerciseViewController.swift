//
//  NewExerciseViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class NewExerciseViewController: UIViewController {
    
    // Storyboard Outlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfDefReps: UITextField!
    @IBOutlet weak var btnSave: SimpleButton!
    @IBOutlet weak var sgDifficulty: UISegmentedControl!
    
    // Auxiliar variables
    var isEditionMode: Bool = false
    var exerciseAux: Exercise!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditionMode { setTextFields(exercise: exerciseAux) }
        
        btnSave.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
    }
    
    // If exercise is saved close view
    @objc func btnSaveTapped () {
        if saveExercise() {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Saves exercise if name is provided
    func saveExercise () -> Bool {
        // Verify if tfName is empty
        let name = tfName.text!.trimmingCharacters(in: .whitespaces)
        if name.isEmpty {
            sendAlert()
            return false
        }
        
        // Verify and get defaults for UITextField if needed
        let exerciseType = tfIsEmpty(field: tfType, defaultText: "None")
        let exerciseReps = tfIsEmpty(field: tfDefReps, defaultText: "10")
        let exerciseDifficulty = sgDifficulty.titleForSegment(at: sgDifficulty.selectedSegmentIndex)!
        
        // Create and send newExercise to delegate
        let newExercise = Exercise(name: name, type: exerciseType, defRepetitions: Int(exerciseReps)!, difficulty: exerciseDifficulty)
        if isEditionMode {
            newExercise.setID(exerciseAux._id)
            let notificationObj = ["exercise" : newExercise]
            let updateExerciseNotification = Notification.Name(rawValue: "updateExercise")
            NotificationCenter.default.post(name: updateExerciseNotification, object: notificationObj)
        } else {
            let notificationObj = ["exercise" : newExercise]
            let newExerciseNotification = Notification.Name(rawValue: "newExercise")
            NotificationCenter.default.post(name: newExerciseNotification, object: notificationObj)
        }
        return true
    }
    
    // MARK: - Utils
    // Alert to ask for at least an exercise name
    func sendAlert() {
        let alert = UIAlertController(title: "Hey!", message: "Your exercise needs at least a name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)
    }
    
    // Verify if a UITextField is empty if it is return defaultText
    func tfIsEmpty(field: UITextField, defaultText: String) -> String {
        let textField = field.text!.trimmingCharacters(in: .whitespaces)
        if textField.isEmpty {
            return defaultText
        }
        return textField
    }
    
    func setTextFields(exercise: Exercise) {
        lbTitle.text = "Edit Exercise"
        tfName.text = exercise.name
        tfType.text = exercise.type
        tfDefReps.text = String(exercise.defRepetitions)
        let index = getSegmentedControlIndex(difficulty: exercise.difficulty)
        sgDifficulty.selectedSegmentIndex = index
    }
    
    func getSegmentedControlIndex(difficulty: String) -> Int {
        switch difficulty {
        case "Easy":
            return 0
        case "Medium":
            return 1
        case "Hard":
            return 2
        default:
            return 0
        }
    }
    
    // MARK: - TODO
}
