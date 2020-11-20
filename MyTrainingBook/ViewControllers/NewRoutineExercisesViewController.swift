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
    var newRoutine: Routine!
    var isEditionMode: Bool = false
    
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
        if saveRoutine() {
            if isEditionMode {
                for vwController in self.navigationController!.viewControllers {
                    if vwController is RoutineDetailViewController {
                        self.navigationController!.popToViewController(vwController, animated: true)
                    }
                }
            }
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
        
        // Add exercises and send newExercise to Observer
        newRoutine.setExercises(exercises: selectedExercises)
        let notificationObj = ["routine" : newRoutine]
        if isEditionMode {
            let updateRoutineNotification = Notification.Name(rawValue: "updateRoutine")
            NotificationCenter.default.post(name: updateRoutineNotification, object: notificationObj)
        } else {
            let newRoutineNotification = Notification.Name(rawValue: "newRoutine")
            NotificationCenter.default.post(name: newRoutineNotification, object: notificationObj)
        }
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
