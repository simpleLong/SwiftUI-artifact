//
//  Home.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var questionStore  = QuestionStore()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    var body: some View {
        
        NavigationView{
            
            GeometryReader { bounds in
                ScrollView {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 20) {
                                ForEach(questionStore.sections) { item in
                                    GeometryReader { geometry in
                                        SectionView(section: item)
                                            .rotation3DEffect(Angle(degrees:
                                                                        Double(geometry.frame(in: .global).minX - 30) / -getAngleMultiplier(bounds: bounds)
                                            ), axis: (x: 0, y: 10, z: 0))
                                    }
                                    .frame(width: 275, height: 275)
                                }
                            }
                            .padding(30)
                            .padding(.bottom, 30)
                        }
                        .offset(y: -30)
                        // .blur(radius: self.active ? 20 : 0)
                        
                        HStack {
                            Text("Courses")
                                .font(.title).bold()
                            Spacer()
                        }
                        .offset(y: -50)
                        
                        VStack(spacing: 30) {
                            ForEach(questionStore.sections.indices, id: \.self) { index in
                                GeometryReader { geometry in
                                    
                                    AlgorithmCourseView(course: questionStore.sections[index], show: self.$questionStore.sections[index].show,
                                                        active: $active,
                                                        activeIndex: $activeIndex,
                                                        activeView: $activeView,
                                                        index: index,
                                                        questionItems: getTheSectionQuestions(questionStore.questions, self.questionStore.sections[index]))
                                        .offset(y: self.questionStore.sections[index].show ? -geometry.frame(in: .global).minY : 0)
                                        .opacity(self.activeIndex != index && self.active ? 0 : 1)
                                        .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
                                        .offset(x: self.activeIndex != index && self.active ? bounds.size.width : 0)
                                    
                                    
                                    
                                }
                                .frame(height: self.horizontalSizeClass == .regular ? 80 : 280)
                                .frame(maxWidth: self.questionStore.sections[index].show ? 712 : getCardWidth(bounds: bounds))
                                .zIndex(self.questionStore.sections[index].show ? 1 : 0)
                            }
                        }
                        .padding(.bottom, 300)
                        .offset(y: -60)
                        
                    }
                }.onAppear(){
                    
                }
                
                
            }
            //                    List{
            //                        ForEach(questionStore.sections) { section in
            //                            NavigationLink(
            //                                destination: Text("Destination"),
            //                                label: {
            //                                    AlgorithmCourseView(course: section ,show: false)
            //                                })
            //
            //                        }
            //
            //            }
            
            
            
            
            
        }
    }
}
func getTheSectionQuestions( _ questions:[Question],_ section: Section) -> [Question] {
    var res : [Question] = []
    for question in questions {
        if let topicTags = question.topicTags {
            for tag in topicTags {
                if tag["name"] == section.topicTag {
                    res.append(question)
                }
            }
        }
    }
    return res
}

func getAngleMultiplier(bounds: GeometryProxy) -> Double {
    if bounds.size.width > 500 {
        return 80
    } else {
        return 20
    }
}

func getCardWidth(bounds: GeometryProxy) -> CGFloat {
    if bounds.size.width > 712 {
        return 712
    }
    
    return bounds.size.width - 60
}
let screen = UIScreen.main.bounds
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
