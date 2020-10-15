//
//  ExercisesViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewExerciseProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    //    Prototype List
    var listExercises = [
        Exercise(name: "exercise 1", type: "type 1", instructions: "", defRepetitions: 10),
        Exercise(name: "exercise 2", type: "type 2", instructions: "", defRepetitions: 10),
        Exercise(name: "exercise 3", type: "type 3", instructions: "", defRepetitions: 10),
        Exercise(name: "exercise 4", type: "type 4", instructions: "", defRepetitions: 10),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods For Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = listExercises[indexPath.row].name
        cell.detailTextLabel?.text = listExercises[indexPath.row].type
        return cell
    }
    
    // MARK: - Protocol Management
    func createExercise(newExercise: Exercise) {
        listExercises.append(newExercise)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vwNewExercise = segue.destination as! NewExerciseViewController
        vwNewExercise.delegate = self
    }
    
    // MARK: - TODO'S
    // 1 - Save exercise info in internal file.
    // 2 - Delete Exercises
}
