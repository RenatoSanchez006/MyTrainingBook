//
//  ExerciseDetailViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 05/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

protocol UpdateExerciseProtocol {
    func updateExercise(index: Int, exercise: Exercise)
}

class ExerciseDetailViewController: UIViewController {
    
    // Storyboard Outlets
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lbType: UITextField!
    @IBOutlet weak var lbReps: UITextField!
    @IBOutlet weak var sgDifficulty: UISegmentedControl!
    
    @IBOutlet weak var btnSave: SimpleButton!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    @IBOutlet weak var typeToNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var typeToSafeAreaConstraint: NSLayoutConstraint!
    
    // General variables
    var isEditionMode: Bool = false
    var exercise: Exercise!
    var exerciseIndex: Int!
    var delegate: UpdateExerciseProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFields(exercise: exercise)
        btnSave.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Logic
    @IBAction func btnEditTapped(_ sender: Any) {
        setEditionMode()
    }
    
    @objc func btnSaveTapped() {
        if saveExercise() {
            setEditionMode()
        }
    }
    
    func setEditionMode() {
        if isEditionMode {
            typeToNameConstraint.priority = UILayoutPriority.defaultLow
            typeToSafeAreaConstraint.priority = UILayoutPriority.defaultHigh
            setTextFields(exercise: self.exercise)
        } else {
            typeToSafeAreaConstraint.priority = UILayoutPriority.defaultLow
            typeToNameConstraint.priority = UILayoutPriority.defaultHigh
        }
        activateTextFields(mode: !isEditionMode)
        isEditionMode = !isEditionMode
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
        let exerciseType = tfIsEmpty(field: lbType, defaultText: "None")
        let exerciseReps = tfIsEmpty(field: lbReps, defaultText: "10")
        let exerciseDifficulty = sgDifficulty.titleForSegment(at: sgDifficulty.selectedSegmentIndex)!
        
        // Update and send newExercise to delegate
        self.exercise = Exercise(name: name, type: exerciseType, defRepetitions: Int(exerciseReps)!, difficulty: exerciseDifficulty)
        delegate.updateExercise(index: self.exerciseIndex, exercise: self.exercise)
        return true
    }
    
    
    // MARK: - Utils
    func activateTextFields(mode: Bool) {
        btnEdit.title = mode ? "Cancel" : "Edit"
        lbName.isHidden = !mode
        tfName.isHidden = !mode
        btnSave.isHidden = !mode
        lbType.isEnabled = mode
        lbReps.isEnabled = mode
        sgDifficulty.isEnabled = mode
    }
    
    func setTextFields(exercise: Exercise) {
        navigationItem.title = exercise.name
        tfName.text = exercise.name
        lbType.text = exercise.type
        lbReps.text = String(exercise.defRepetitions)
        let index = getSegmentedControlIndex(difficulty: exercise.difficulty)
        sgDifficulty.selectedSegmentIndex = index
    }
    
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
    
}
