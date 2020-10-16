//
//  Question.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/11.
//

import SwiftUI

struct QuestionResponse :Codable{
    var code :Int
    var data : QuestionData
    //var msg :String
    
    
}
struct Question :Codable ,Identifiable {
    var id: UUID = UUID()
    
    
    var questionId :Int
    var questiontitle :String
    var questionslug :String
    var passRate :String
    var difficulty: String
    var frontendQuestionId :String
    
    var columnArticles :Int
    var status :String?
    var paidOnly :Bool
    
    enum CodingKeys :String,CodingKey {
        case questionId
        case questiontitle
        case questionslug
        case passRate
        case difficulty
        case frontendQuestionId
        case columnArticles
        case status
        case paidOnly
    }


}
struct QuestionData :Codable{
    var userName :String
    var numSolved :Int
    var numTotal :Int
    var acEasy :Int
    var acMedium :Int
    var acHard :Int

    var questions : [Question]

}
struct Stat :Codable {
    var questionId :Int
    var questionTitle :String
    var questionTitleSlug :String
    var questionHide :Bool
    var totalAcs :Int
    var totalSubmitted :Int
    var totalColumnArticles :Int
    var frontendQuestionId :String
    var isNewQuestion :Bool
    enum CodingKeys: String,CodingKey {
        case questionId = "question_id"
        case questionTitle = "question__title"
        case questionTitleSlug = "question__title_slug"
        case questionHide = "question__hide"
        case totalAcs = "total_acs"
        case totalSubmitted = "total_submitted"
        case totalColumnArticles = "total_column_articles"
        case frontendQuestionId = "frontend_question_id"
        case isNewQuestion = "is_new_question"
    }

}
