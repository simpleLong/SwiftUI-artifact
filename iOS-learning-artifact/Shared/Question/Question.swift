//
//  Question.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/11.
//

import SwiftUI
import ObjectMapper
struct QuestionResponse :Codable{
    var code :Int
    var data : QuestionData
    //var msg :String
    
    
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
struct Question :Codable ,Identifiable ,Mappable {
    
    
    var id = UUID()
    
    var difficultyLabelColor : Color{
        guard let difficulty = difficulty else {
            return Color(#colorLiteral(red: 0, green: 0.5790003538, blue: 0.4385164976, alpha: 1))
        }
        let colorDict = ["Easy":Color(#colorLiteral(red: 0, green: 0.5790003538, blue: 0.4385164976, alpha: 1)),"Medium":Color(#colorLiteral(red: 0.8819206953, green: 0.5761888623, blue: 0.4387951195, alpha: 1)),"Hard":Color(#colorLiteral(red: 0.8828930855, green: 0.2852645516, blue: 0.2618650198, alpha: 1))]
        return colorDict[difficulty]!
        
    }
    
    var questionId :String?
    var questionTitle :String?
    var questionslug :String?
    //  var passRate :String?
    var difficulty: String?
    var questionFrontendId :String?
    var translatedTitle :String?
    
    
    var status :String?
    
    var topicTags:[[String:String]]?
    var translatedContent :String?
    var logo :String?
    var stats : [String:String]?
    
    var passRate: String{
        
        guard let stats = stats else {return ""}
        guard let acRate = stats["acRate"] else {return ""}
        
        return acRate
        
    }
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        questionId <- map["questionId"]
        questionFrontendId <- map["questionFrontendId"]
        questionTitle <- map["questionTitle"]
        translatedTitle <- map["translatedTitle"]
        questionslug <- map["questionTitleSlug"]
        difficulty <- map["difficulty"]
        translatedContent <- map["translatedContent"]
        topicTags <- map["topicTags"]
    }
    
    
    init() {
        
    }
    
    
    
}
