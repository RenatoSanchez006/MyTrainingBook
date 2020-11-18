//
//  NewRoutineExercisesViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 17/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class NewRoutineExercisesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var btnSave: SimpleButton!
    @IBOutlet weak var tableView: UITableView!
    
    // Exercises List
    var exerciseList: [Exercise] = []
    var selectedExercises: [Exercise] = []
    
    // Auxiliar variables
    var nameAux: String!
    var typeAux: String!
    var setsAux: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for button click
        btnSave.addTarget(self, action: #selector(btnSaveTapped), for: .touchUpInside)
        
        // Register Custom Table View Cell
        tableView.register(UINib(nibName: "ExerciseCellTableViewCell", bundle: nil), forCellReuseIdentifier: "exerciseCell")
        
        // Get Exercises saved
        if FileManager.default.fileExists(atPath: getFileUrl().path) {
            getExercises()
        }
    }
    
    // Save routine and pop to root view controller
    @objc func btnSaveTapped() {
        if saveRoutine(){
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // Save Routine
    func saveRoutine() -> Bool {
        // Verify if tfName is empty
        if selectedExercises.isEmpty {
            sendAlert()
            return false
        }
        
        // Create and send newExercise to Observer
        let newRoutine = ["routine" : Routine(name: nameAux, type: typeAux, exercises: selectedExercises, routineSets: Int(setsAux))]
        let notification = Notification.Name(rawValue: "didReceiveRoutine")
        NotificationCenter.default.post(name: notification, object: newRoutine)
        
        return true
    }
    
    // Alert to ask for at least one exercise
    func sendAlert() {
        let alert = UIAlertController(title: "Hey!", message: "Your routine needs at least one exercise", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)
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
