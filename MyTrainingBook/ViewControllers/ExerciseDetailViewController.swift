//
//  ExerciseDetailViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 05/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {
    
    @IBOutlet weak var lbType: UITextField!
    @IBOutlet weak var lbReps: UITextField!
    @IBOutlet weak var sgDifficulty: UISegmentedControl!
    
    var exercise: Exercise!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
