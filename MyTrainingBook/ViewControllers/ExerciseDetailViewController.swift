//
//  ExerciseDetailViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 05/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {
    
    // Storyboard Outlets
    @IBOutlet weak var lbType: UITextField!
    @IBOutlet weak var lbReps: UITextField!
    @IBOutlet weak var sgDifficulty: UISegmentedControl!
    
    // General variables
    var exercise: Exercise!
    
    let updateExerciseNotification = Notification.Name(rawValue: "updateExercise")
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFields(exercise: exercise)
        
        // Creating Observer for updated Exercise
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidReceiveUpdatedExercise(_:)),
            name: updateExerciseNotification,
            object: nil
        )
    }
    
    // MARK: - Observer Methods
    @objc func onDidReceiveUpdatedExercise(_ notification: Notification) {
        let dictionary = notification.object as! NSDictionary
        let data = dictionary["exercise"] as! Exercise
        self.exercise = data
        setTextFields(exercise: self.exercise)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vwEditExercise = segue.destination as! NewExerciseViewController
        vwEditExercise.isEditionMode = true
        vwEditExercise.exerciseAux = exercise
    }
    
    // MARK: - Utils
    func setTextFields(exercise: Exercise) {
        navigationItem.title = exercise.name
        lbType.text = exercise.type
        lbReps.text = String(exercise.defRepetitions)
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
    
}
