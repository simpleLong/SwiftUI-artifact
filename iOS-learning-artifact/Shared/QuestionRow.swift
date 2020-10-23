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
struct QuestionRow: View {

    
    var questionItem : Question? =   Question.init(JSON: jsonstr)
    var body: some View {
        HStack(alignment: .top){
            
            Image("Check_in")
                .resizable()
                .frame(width: 20, height: 20)
            
            VStack(alignment:.leading) {
                HStack{
                    Text("1.")
                        .font(.headline)
                    Text(questionItem!.questionTitle!)
                        .font(.headline)
                }
                HStack{
                    Text(questionItem!.difficulty!)
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
