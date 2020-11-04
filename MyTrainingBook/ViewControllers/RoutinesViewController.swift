//
//  RoutinesViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 02/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class RoutinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, newRoutineProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Dummy List
    var listRoutines: [Routine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if FileManager.default.fileExists(atPath: getFileUrl().path){
            getRoutines()
        }
    }
    
    // MARK: - Methods for Table View Controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRoutines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell")!
        cell.textLabel?.text = listRoutines[indexPath.row].name
        cell.detailTextLabel?.text = listRoutines[indexPath.row].type
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listRoutines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveRoutines()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Protocol Management
    func createRoutine(newRoutine: Routine) {
        listRoutines.append(newRoutine)
        tableView.reloadData()
        saveRoutines()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newRoutineSegue" {
            let vwNewRoutine = segue.destination as! NewRoutineViewController
            vwNewRoutine.delegate = self
        }
    }
    
    // MARK: - Persistance Management
    func getFileUrl() -> URL {
        let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = url.appendingPathComponent("Routines.plist")
        return filePath
    }
    
    @objc func saveRoutines() {
        do {
            let data = try PropertyListEncoder().encode(listRoutines)
            try data.write(to: getFileUrl())
        }
        catch {
            print("Couldn't write in the file")
        }
    }
    
    func getRoutines () {
        listRoutines.removeAll()
        do {
            let data = try Data.init(contentsOf: getFileUrl())
            listRoutines = try PropertyListDecoder().decode([Routine].self, from: data)
        }
        catch {
            print("Couldn't load file")
        }
        tableView.reloadData()
    }

}
