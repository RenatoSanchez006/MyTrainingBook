//
//  ExercisesViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource,
    NewExerciseProtocol, UpdateExerciseProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var exerciseList: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FileManager.default.fileExists(atPath: getFileUrl().path) {
            getExercises()
        }
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
    
    // MARK: - Protocol Management
    func createExercise(newExercise: Exercise) {
        exerciseList.append(newExercise)
        tableView.reloadData()
        saveExercises()
    }
    
    func updateExercise(index: Int, exercise: Exercise) {
        exerciseList[index] = exercise
        tableView.reloadData()
        saveExercises()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newExerciseSegue" {
            let vwNewExercise = segue.destination as! NewExerciseViewController
            vwNewExercise.delegate = self
        } else {
            let index = tableView.indexPathForSelectedRow!.row
            let selectedExercise = exerciseList[index]
            let vwDetailExercise = segue.destination as! ExerciseDetailViewController
            vwDetailExercise.exercise = selectedExercise
            vwDetailExercise.exerciseIndex = index
            vwDetailExercise.delegate = self
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
