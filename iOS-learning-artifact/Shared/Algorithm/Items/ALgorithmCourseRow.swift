//
//  ALgorithmCourseRow.swift
//  iOS-learning-artifact
//
//  Created by 龙晓东 on 2020/9/16.
//

import SwiftUI

struct ALgorithmCourseRow: View {
    var item: AlgorithmCourseSection = alCourseSections[0]
//    let questions = Bundle.main.decode(QuestionResponse.self, from: "questions.json").data.statStatusPairs[0]
//    var questionItem : StatStatusPair = Bundle.main.decode(QuestionResponse.self, from: "questions.json").data.statStatusPairs[0]
    
    var body: some View {
        HStack(alignment: .top) {
            Image(item.logo)
                .renderingMode(.original)
                .frame(width: 48.0, height: 48.0)
                .imageScale(.medium)
                .background(item.color)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4.0) {
//                Text(questionItem.stat.questionTitle)
//                    .font(.subheadline)
//                    .bold()
//                    .foregroundColor(.primary)
                Text(item.subtitle)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

struct ALgorithmCourseRow_Previews: PreviewProvider {
    static var previews: some View {
        ALgorithmCourseRow()
    }
}
