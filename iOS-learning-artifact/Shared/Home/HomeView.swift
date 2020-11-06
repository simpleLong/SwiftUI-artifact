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
    @Binding var showProfile: Bool
    @State var viewState = CGSize.zero
    @EnvironmentObject var user: UserStore
    var body: some View {

            
        NavigationView {
            ZStack {
                    GeometryReader { bounds in
                        ScrollView {
                            VStack {

                                    HStack(spacing: 12) {
                                        Text("Algorithm classification display")
                                            .modifier(CustomFontModifier(size: 18))
                                            .padding()
                                        
                                        Spacer()
                                        
                                        AvatarView(showProfile: self.$showProfile)
                                    }

                                // MARK: -3d scrollView 滑动栏
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
                                
                                HStack(spacing:15) {
                                    Text("Algorithm Category")
                                        .padding(15)
                                        .font(.headline)
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
                        }
                    }
                    // MARK: -显示登陆页面
                    if user.showLogin {
                        ZStack {
                            LoginView(updateQuestionsBlock: { isLoginSuccess in
                                
                                if isLoginSuccess {
                                    questionStore.getquestions()
                                }
                                
                            })
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "xmark")
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                            .padding()
                            .onTapGesture {
                                self.user.showLogin = false
                            }
                        }
                    }
                LoadingView()
                    .opacity(questionStore.questions.count == 0 ? 1 : 0)

            }
            
            .navigationBarHidden(true)
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
        HomeView(showProfile: .constant(false))
    }
}
// MARK: -头像
struct AvatarView: View {
    @Binding var showProfile: Bool
    @EnvironmentObject var user: UserStore
    
    var body: some View {
        VStack {
            if user.isLogged {
                Button(action: { self.showProfile.toggle() }) {
                Image("avatar")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .padding()
                }
            } else {
                Button(action: { self.user.showLogin.toggle() }) {
                Image(systemName: "person")
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(Color("background3"))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    
                }.padding()
            }
        }
    }
}
//struct HomeBackgroundView: View {
//    @Binding var showProfile: Bool
//
//    var body: some View {
//        VStack {
//            LinearGradient(gradient: Gradient(colors: [Color("background2"), Color("background1")]), startPoint: .top, endPoint: .bottom)
//                .frame(height: 200)
//            Spacer()
//        }
//        .background(Color("background1"))
//        .clipShape(RoundedRectangle(cornerRadius: showProfile ? 30 : 0, style: .continuous))
//        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
//    }
//}
