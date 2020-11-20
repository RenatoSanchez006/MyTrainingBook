//
//  Routine.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 02/11/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class Routine: Codable {
    var _id: UUID!
    var name: String!
    var type: String!
    var exercises: [Exercise]!
    var routineSets: Int!
    var instructions: String!
    var difficulty: String!
    
    init(name: String, type: String, routineSets: Int, instructions: String, difficulty: String) {
        self._id = UUID()
        self.name = name
        self.type = type
        self.routineSets = routineSets
        self.instructions = instructions
        self.difficulty = difficulty
    }
    
    public func setExercises(exercises: [Exercise]) {
        self.exercises = exercises
    }
    
    public func setID(_ id: UUID) {
        self._id = id
    }
}

// MARK: - TODO'S

// Dummy List
//var listRoutines = [
//    Routine(name: "routine 1", type: "type 1", routineSets: 2),
//    Routine(name: "routine 2", type: "type 2", routineSets: 4),
//    Routine(name: "routine 3", type: "type 3", routineSets: 2),
//    Routine(name: "routine 4", type: "type 4", routineSets: 4),
//    Routine(name: "routine 5", type: "type 5", routineSets: 2),
//]
