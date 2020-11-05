//
//  ExerciseCellTableViewCell.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 04/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class ExerciseCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbReps: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initExerciseCell(exercise: Exercise) {
        self.lbName.text = exercise.name
        self.lbType.text = exercise.type
        self.lbReps.text = String(exercise.defRepetitions)
    }
}
