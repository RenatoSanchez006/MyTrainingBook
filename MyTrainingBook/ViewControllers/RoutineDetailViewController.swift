//
//  RoutineDetailViewController.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 04/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class RoutineDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var routineAux: Routine!
    var routineExercises: [Exercise] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = routineAux.name
        routineExercises = routineAux.exercises
        tableView.register(UINib(nibName: "ExerciseCellTableViewCell", bundle: nil), forCellReuseIdentifier: "exerciseCell")
        
    }
    
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
