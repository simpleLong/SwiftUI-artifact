//
//  DataStore.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI

import Combine


class QuestionStore: ObservableObject {
    @Published var questions : [Question] = []
    @Published var sections : [Section] = []
    
    init() {
        getquestions()
    }
    func getquestions() {
        Api().getquestions { (questions,sections) in
            self.questions = questions
            self.sections = sections
        }
    }
    

}
