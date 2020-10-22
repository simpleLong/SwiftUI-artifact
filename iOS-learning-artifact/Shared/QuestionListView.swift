//
//  QuestionListView.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/12.
//

import SwiftUI

struct QuestionListView: View {
    var questionItems : [Question] = Bundle.main.decode(QuestionResponse.self, from: "questions.json").data.questions
    var body: some View {
        NavigationView{
            List{
                ForEach(questionItems){ questionItem in
                    
                    NavigationLink(
                        destination: QuestionDetail(titleSlug:questionItem.questionslug!)){
                        QuestionRow(questionItem: questionItem)
                    }
                    
                }
            }
        }

        
    }
}

struct QuestionListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionListView()
    }
}
