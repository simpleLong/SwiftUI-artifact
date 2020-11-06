//
//  QuestionCategoryDetail.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/26.
//

import SwiftUI

struct QuestionCategoryDetail: View {
    
    var course: Section
    @Binding var show: Bool
    @Binding var active: Bool
    @Binding var activeIndex : Int
    
    var questionItems : [Question]
    @State var showDetail = false
    
    var body: some View {
        

        ScrollView {
            VStack{
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8.0) {
                            Text(course.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text(course.subtitle)
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        Spacer()
                        ZStack {
                            Image(course.logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .opacity(show ? 0 : 1)
                            
                            
                            VStack {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                            }
                            
                            .frame(width: 36, height: 36)
                            .background(Color.black)
                            .clipShape(Circle())
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                self.show = false
                                self.active = false
                                self.activeIndex = -1
                            })
                            
                        }
                    }
                    Spacer()
                    course.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 140, alignment: .top)
                    
                }
                .padding(show ? 30 : 20)
                .padding(.top, show ? 30 : 0)
                
                .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight:  280)
                .background(course.color)
                .cornerRadius(25)
                .shadow(color: course.shadowColor.opacity(0.3), radius: 20, x: 0, y: 20)
                
                
                VStack {
                    ForEach(questionItems.indices,id:\.self){ index in
                        
                        NavigationLink(
                            destination: QuestionDetail(questionDetail: questionItems[index], down: Down(), showSelf: $showDetail),isActive: $showDetail ,
                            label: {
                                QuestionRow(questionItem: questionItems[index], index: index)
                            })
                    }
                }
                .padding(.top,30)

            }

        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct QuestionCategoryDetail_Previews: PreviewProvider {
    static let  questionItems = [questionData!,questionData!,questionData!,questionData!,questionData!]
    static var previews: some View {
        QuestionCategoryDetail(course: sectionsData[0], show: .constant(true), active: .constant(true), activeIndex: .constant(-1), questionItems: questionItems)
    }
}
