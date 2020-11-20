//
//  NewRoutineViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 02/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class NewRoutineViewController: UIViewController {
    
    // Storyboard Outlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfSets: UITextField!
    @IBOutlet weak var tfInstructions: UITextField!
    @IBOutlet weak var sgDifficulty: UISegmentedControl!
    @IBOutlet weak var btnNext: SimpleButton!
    
    var isEditionMode: Bool = false
    var routineAux: Routine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditionMode { setTextFields(routine: routineAux) }
    }
    
    // MARK: - Utils
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vwRoutineExercises = segue.destination as! NewRoutineExercisesViewController
        // Verify if tfName is empty
        let name = tfName.text!.trimmingCharacters(in: .whitespaces)
        if name.isEmpty {
            sendAlert()
        }
        
        // Verify and get defaults for UITextField if needed
        let routineType = tfIsEmpty(field: tfType, defaultText: "None")
        let routineSets = Int(tfIsEmpty(field: tfSets, defaultText: "3"))!
        let routineInstructions = tfIsEmpty(field: tfInstructions, defaultText: "None")
        let routineDifficulty = sgDifficulty.titleForSegment(at: sgDifficulty.selectedSegmentIndex)!
        
        let newRoutine = Routine(name: name, type: routineType, routineSets: routineSets, instructions: routineInstructions, difficulty: routineDifficulty)
        if isEditionMode { newRoutine.setID(routineAux._id) }
        vwRoutineExercises.newRoutine = newRoutine
        vwRoutineExercises.isEditionMode = isEditionMode
    }
    
    // Alert to ask for at least an exercise name
    func sendAlert() {
        let alert = UIAlertController(title: "Hey!", message: "Your routine needs at least a name", preferredStyle: .alert)
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
    
    func setTextFields(routine: Routine) {
        navigationItem.title = "Edit Routine"
        tfName.text = routine.name
        tfType.text = routine.type
        tfSets.text = String(routine.routineSets)
        tfInstructions.text = routine.instructions
        let index = getSegmentedControlIndex(difficulty: routine.difficulty)
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
}

// MARK: - TODO's
// As a user I should be able to set
// for each exercise reps when I create a new Routine
