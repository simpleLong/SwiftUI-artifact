//
//  QuestionRow.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/12.
//

import SwiftUI
let jsonstr  : [String : Any] = [
    "questionId": "1",
    "questionFrontendId": "1",
    "questionTitle": "Two Sum",
    "translatedTitle": "两数之和",
    "questionTitleSlug": "two-sum",
    "difficulty": "Easy",
    "stats": "{\"totalAccepted\": \"1.5M\", \"totalSubmission\": \"3M\", \"totalAcceptedRaw\": 1476743, \"totalSubmissionRaw\": 2970468, \"acRate\": \"49.7%\"}",
    "translatedContent": "<p>给定一个整数数组 <code>nums</code>&nbsp;和一个目标值 <code>target</code>，请你在该数组中找出和为目标值的那&nbsp;<strong>两个</strong>&nbsp;整数，并返回他们的数组下标。</p>\n\n<p>你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。</p>\n\n<p>&nbsp;</p>\n\n<p><strong>示例:</strong></p>\n\n<pre>给定 nums = [2, 7, 11, 15], target = 9\n\n因为 nums[<strong>0</strong>] + nums[<strong>1</strong>] = 2 + 7 = 9\n所以返回 [<strong>0, 1</strong>]\n</pre>\n",
]
let questionData =  Question.init(JSON: jsonstr)
struct QuestionRow: View {
    
    
    var questionItem : Question?
    var index : Int
    
    var body: some View {
        HStack(alignment: .top ){
            
            VStack(alignment:.leading,spacing: 10) {
                HStack(alignment: .top){
                    Text("\(index).")
                        .font(.system(size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0.501908958, green: 0.5019971728, blue: 0.5018973947, alpha: 1)))
                        .padding(.leading,10)
                    Text(questionItem!.translatedTitle!)
                        .font(.system(size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5332205892, blue: 0.7979013324, alpha: 1)))
                }
                HStack{
                    Text(questionItem!.difficulty!)
                        .font(.system(size: 14))
                        .foregroundColor(questionItem?.difficultyLabelColor)
                        .padding(.leading,10)
                    
                    Text("通过率" + questionItem!.passRate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
            }.padding(.top,10)
            Spacer()
            
            
        }.padding(.bottom)
        .background(index % 2 == 0 ? Color(#colorLiteral(red: 0.9802958369, green: 0.9804597497, blue: 0.98027426, alpha: 1)) : Color(#colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)))
        
    }
    
    
}

struct QuestionRow_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRow(index: 0)
    }
}
