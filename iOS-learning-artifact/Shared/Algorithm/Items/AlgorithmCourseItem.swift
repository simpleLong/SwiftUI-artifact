//
//  AlgorithmCourseItem.swift
//  iOS-learning-artifact
//
//  Created by 龙晓东 on 2020/9/16.
//

import SwiftUI

struct AlgorithmCourseItem: View {
    var course: AlgorithmCourse = algorithmCourses[0]
    #if os(iOS)
    var cornerRadius: CGFloat = 22
    #else
    var cornerRadius: CGFloat = 10
    #endif
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Spacer()
            HStack {
                Spacer()
                Image(course.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            Text(course.title).fontWeight(.bold).foregroundColor(Color.white)
            Text(course.subtitle).font(.footnote).foregroundColor(Color.white)
        }
        .padding(.all)
        .background(course.color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: course.color.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct AlgorithmCourseItem_Previews: PreviewProvider {
    static var previews: some View {
        AlgorithmCourseItem()
    }
}
