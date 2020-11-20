//
//  ExercisesViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var exerciseList: [Exercise] = []
    
    let updateExerciseNotification = Notification.Name(rawValue: "updateExercise")
    let newExerciseNotification = Notification.Name(rawValue: "newExercise")
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FileManager.default.fileExists(atPath: getFileUrl().path) {
            getExercises()
        }
        
        // Creating Observer for updated and newExercise
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidReceiveUpdatedExercise(_:)),
            name: updateExerciseNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDidReceiveNewExercise),
            name: newExerciseNotification,
            object: nil
        )
    }
    
    // MARK: - Methods For Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = exerciseList[indexPath.row].name
        cell.detailTextLabel?.text = exerciseList[indexPath.row].type
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            exerciseList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveExercises()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Observer functions
    @objc func onDidReceiveUpdatedExercise(_ notification: Notification) {
        let dictionary = notification.object as! NSDictionary
        let data = dictionary["exercise"] as! Exercise
        let index = exerciseList.firstIndex(where: { $0._id == data._id })!
        exerciseList[index] = data
        tableView.reloadData()
        saveExercises()
    }
    
    @objc func onDidReceiveNewExercise(_ notification: Notification) {
        let dictionary = notification.object as! NSDictionary
        let data = dictionary["exercise"] as! Exercise
        exerciseList.append(data)
        tableView.reloadData()
        saveExercises()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exerciseDetailSegue" {
            let selectedExercise = exerciseList[tableView.indexPathForSelectedRow!.row]
            let vwDetailExercise = segue.destination as! ExerciseDetailViewController
            vwDetailExercise.exercise = selectedExercise
        }
    }
    
    // MARK: - Persistence Management
    func getFileUrl() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = url.appendingPathComponent("Exercises.plist")
        return filePath
    }
    
    @objc func saveExercises() {
        do {
            let data = try PropertyListEncoder().encode(exerciseList)
            try data.write(to: getFileUrl())
        }
        catch {
            print("Couldn't write in the file")
        }
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
    
    // MARK: - TODO'S
}
