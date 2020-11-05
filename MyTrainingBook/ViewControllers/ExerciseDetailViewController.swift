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
    @IBOutlet weak var lbInstructions: UITextField!
    @IBOutlet weak var lbReps: UITextField!
    
    var exercise: Exercise!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = exercise.name
        lbType.text = exercise.type
        lbInstructions.text = exercise.instructions
        lbReps.text = String(exercise.defRepetitions)
    }
}
