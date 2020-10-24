//
//  QuestionRow.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/12.
//

import SwiftUI

struct QuestionRow: View {
    var questionItem : Question = Question()
    var body: some View {
        HStack(alignment: .top){
            
            Image("Check_in")
                .resizable()
                .frame(width: 20, height: 20)
            
            VStack(alignment:.leading) {
                HStack{
                    Text("1.")
                        .font(.headline)
                    Text(questionItem.questionTitle!)
                        .font(.headline)
                }
                HStack{
                    Text(questionItem.difficulty!)
                        .font(.subheadline)
                    
                    Text("通过率+ questionItem.passRate!" )
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("题解+ String(questionItem.columnArticles)" )
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            
        }
        
    }
    
    
}

struct QuestionRow_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRow()
    }
}
