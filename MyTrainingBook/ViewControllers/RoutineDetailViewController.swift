//
//  RoutineDetailViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 04/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class RoutineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbType: UITextField!
    @IBOutlet weak var lbSets: UITextField!
    @IBOutlet weak var lbInstructions: UITextField!
    @IBOutlet weak var sgDifficulty: UISegmentedControl!
    @IBOutlet weak var btnStart: SimpleButton!
    
    var routineAux: Routine!
    var routineExercises: [Exercise] = []
    
    let updateRoutineNotification = Notification.Name(rawValue: "updateRoutine")
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the view
        setTextFields(routine: routineAux)
        tableView.register(UINib(nibName: "ExerciseCellTableViewCell", bundle: nil), forCellReuseIdentifier: "exerciseCell")
        
        // Creating Observer for updated Routine
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveUpdatedRoutine(_:)), name: updateRoutineNotification, object: nil)
    }
    
    // MARK: - Observer Methods
    @objc func onDidReceiveUpdatedRoutine(_ notification: Notification) {
        let dictionary = notification.object as! NSDictionary
        let data = dictionary["routine"] as! Routine
        routineAux = data
        setTextFields(routine: routineAux)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startRoutine" {
            let vwStartRoutine = segue.destination as! StartRoutineViewController
            vwStartRoutine.routineAux = routineAux
        } else {
            // segue identifer is "editRoutine"
            let vwEditRoutine = segue.destination as! NewRoutineViewController
            vwEditRoutine.isEditionMode = true
            vwEditRoutine.routineAux = routineAux
        }
    }
    
    // MARK: - Utils
    func setTextFields(routine: Routine) {
        navigationItem.title = routineAux.name
        lbType.text = routineAux.type
        lbSets.text = String(routineAux.routineSets)
        lbInstructions.text = routineAux.instructions
        let index = getSegmentedControlIndex(difficulty: routineAux.difficulty)
        sgDifficulty.selectedSegmentIndex = index
        
        routineExercises = routineAux.exercises
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
}
