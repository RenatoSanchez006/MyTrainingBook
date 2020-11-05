//
//  Exercise.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class Exercise: Codable {
    var name: String!
    var type: String!
    var instructions: String!
    var defRepetitions: Int!
    var _id: UUID!
    
    init(name: String, type: String, instructions: String, defRepetitions: Int) {
        self._id = UUID()
        self.name = name
        self.type = type
        self.instructions = instructions
        self.defRepetitions = defRepetitions
    }
}

// MARK: - TODO'S

// Dummy List
//var listExercises = [
//    Exercise(name: "exercise 1", type: "type 1", instructions: ""),
//    Exercise(name: "exercise 2", type: "type 2", instructions: ""),
//    Exercise(name: "exercise 3", type: "type 3", instructions: ""),
//    Exercise(name: "exercise 4", type: "type 4", instructions: ""),
//]
