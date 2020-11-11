//
//  QuestionDetailModel.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/13.
//

import SwiftUI

struct QuestionDetailResponse :Codable {
    var code :Int
    var data : QuestionDetailData
    
    
    
}

struct QuestionDetailData :Codable {
    var difficulty :String
    var questionTitleSlug :String
    var translatedContent :String
    var translatedTitle :String

    
}
