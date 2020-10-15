//
//  NewExerciseViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

protocol NewExerciseProtocol {
    func createExercise(newExercise: Exercise)
}

class NewExerciseViewController: UIViewController {
    
    @IBOutlet weak var btnSave: SimpleButton!
    var delegate: NewExerciseProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveExercise()
    }
    
    @objc func btnSaveTapped () {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func saveExercise () {
        let newExercise = Exercise(name: "new exercise", type: "new", instructions: "", defRepetitions: 10)
        delegate.createExercise(newExercise: newExercise)
    }
    
    // MARK: - TODO
    // 1 - Add defRepetitions field
    // 2 - Add outlets to save info in fields
    // 3 - Add restriction so user fills every field    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
