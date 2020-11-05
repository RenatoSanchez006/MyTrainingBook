//
//  NewRoutineViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 02/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

protocol newRoutineProtocol {
    func createRoutine(newRoutine: Routine)
}

class NewRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Storyboard Outlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfSets: UITextField!
    @IBOutlet weak var btnSave: SimpleButton!
    @IBOutlet weak var tableView: UITableView!
    
    var exerciseList: [Exercise] = []
    var selectedExercises: [Exercise] = []
    var delegate: newRoutineProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
        
        // Register Custom Table View Cell
        tableView.register(UINib(nibName: "ExerciseCellTableViewCell", bundle: nil), forCellReuseIdentifier: "exerciseCell")
        
        if FileManager.default.fileExists(atPath: getFileUrl().path) {
            getExercises()
        }
    }
    
    // MARK: - Utils
    // If exercise is saved close view
    @objc func btnSaveTapped () {
        if saveRoutine() {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Saves exercise if name is provided
    func saveRoutine () -> Bool {
        // Verify if tfName is empty
        let name = tfName.text!.trimmingCharacters(in: .whitespaces)
        if name.isEmpty || selectedExercises.isEmpty {
            sendAlert()
            return false
        }
        
        // Verify and get defaults for UITextField if needed
        let routineType = tfIsEmpty(field: tfType, defaultText: "None")
        let routineSets = tfIsEmpty(field: tfSets, defaultText: "3")
        
        // Create and send newExercise to delegate
        let newRoutine = Routine(name: name, type: routineType, exercises: selectedExercises, routineSets: Int(routineSets)!)
        delegate.createRoutine(newRoutine: newRoutine)
        return true
    }
     
    // Alert to ask for at least an exercise name
    func sendAlert() {
        let alert = UIAlertController(title: "Hey!", message: "Your routine needs at least a name and exercises", preferredStyle: .alert)
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
    
    // MARK: - Methods for Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell") as! ExerciseCellTableViewCell
        cell.lbName?.text = exerciseList[indexPath.row].name
        cell.lbType?.text = exerciseList[indexPath.row].type
        cell.lbReps?.text = String(exerciseList[indexPath.row].defRepetitions)
        return cell
    }
    
    // Appending selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExercises.append(exerciseList[indexPath.row])
    }
    
    // Removing deselected row
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let index = selectedExercises.firstIndex { (item) -> Bool in
            item._id == exerciseList[indexPath.row]._id
        }
        selectedExercises.remove(at: index!)
    }
    
    // MARK: - Exercise Persistence Management
    func getFileUrl() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = url.appendingPathComponent("Exercises.plist")
        return filePath
    }
    
    func getExercises() {
        exerciseList.removeAll()
        
        do {
            let data = try Data.init(contentsOf: getFileUrl())
            exerciseList = try PropertyListDecoder().decode([Exercise].self, from: data)
        }
        catch {
            print("Couldn't load file")
        }
        tableView.reloadData()
    }
}

// MARK: - TODO's
// As a user I should be able to set
// for each exercise reps when I create a new Routine
