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

}

class SectionsStore: ObservableObject {
  
    @Published var sections : [Section] = []


}
