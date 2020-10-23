//
//  AlgorithmCourseView.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI

let sectionsData = [
    Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "stack", image: Image(uiImage: #imageLiteral(resourceName: "StarrySkybg0")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array"),
    Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "stack", image: Image(uiImage: #imageLiteral(resourceName: "StarrySkybg0")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array"),
    Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "stack", image: Image(uiImage: #imageLiteral(resourceName: "StarrySkybg0")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array"),
    Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "stack", image: Image(uiImage: #imageLiteral(resourceName: "StarrySkybg0")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array"),
    
    Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "stack", image: Image(uiImage: #imageLiteral(resourceName: "StarrySkybg0")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array")
]
struct AlgorithListView :View {
    @State var sections = sectionsData
    @State var active :Bool = false
    @State var  activeIndex : Int = -1
    @State var activeView : CGSize = .zero
    
    
    
    var body: some View {
        ZStack {
            Color.black.opacity(Double(self.activeView.height/500))
                .animation(.linear)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing:30) {
                    
                    ForEach(sections.indices,id: \.self) { index in
                        GeometryReader { geometry in
                            AlgorithmCourseView(course: sections[index],
                                                show: self.$sections[index].show,
                                                active: $active,
                                                activeIndex: self.$activeIndex,
                                                activeView: $activeView,
                                                index: index,
                                                questionItems: [questionItemData!])
                                .offset(y: self.sections[index].show ? -geometry.frame(in: .global).minY : 0)
                            
                        }
                        .frame(height: 280)
                        .frame(maxWidth: self.sections[index].show ? .infinity : screen.width - 60)
                        .zIndex(self.sections[index].show ? 1 : 0)
                        .opacity(self.activeIndex != index && active ? 0 : 1)
                        .scaleEffect(self.activeIndex != index && active ? 0.5 : 1)
                        .offset(x:self.activeIndex != index && active ? screen.width  : 0)
                    }
                    
                    
                }
                .frame(width: screen.width)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            }
            .statusBar(hidden: active ? true : false)
            .animation(.linear)
        }
    }
    
    struct AlgorithListView_Previews: PreviewProvider {
        
        static var show: Bool = true
        
        static var previews: some View {
            
            AlgorithListView()
        }
    }
    
}
var questionItemData : Question? =  Question.init(JSON: jsonstr)  //Question.init(JSONString: jsonstr)

struct AlgorithmCourseView: View {
    
    var course: Section
    @Binding var show: Bool
    @Binding var active: Bool
    @Binding var activeIndex : Int
    @Binding var activeView : CGSize
    var index : Int
    var questionItems : [Question]
    
    
    //  var bounds: GeometryProxy
    var body: some View {
        
        
        
        ZStack(alignment: .top) {
            
            VStack {
                ForEach(questionItems.indices,id:\.self){ index in
                    
                    NavigationLink(
                        destination: QuestionDetail(questionDetail: questionItems[index]),
                        label: {
                            QuestionRow(questionItem: questionItems[index])
                        })

                }

            }
            .padding(30)
            .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? .infinity : 280, alignment: .top)
            .offset(y: show ? 460 : 0)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .opacity(show ? 1 : 0)
            
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
                        .opacity(show ? 1 : 0)
                        .offset(x: 2, y: -2)
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
            
            .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? 460 : 280)
            .background(course.color)
            .cornerRadius(25)
            .shadow(color: course.shadowColor.opacity(0.3), radius: 20, x: 0, y: 20)
           // .opacity(show ? 1 : 0)
            .gesture(
                show ?
                    DragGesture().onChanged({ (value) in
                        guard value.translation.height < 300 && value.translation.height > 0 else {return}
                        self.activeView = value.translation
                        
                    })
                    .onEnded({ (value) in
                        if self.activeView.height > 50 {
                            self.show = false
                            self.active = false
                            self.activeIndex = -1
                        }
                        self.activeView = .zero
                    }) : nil)
            
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                self.show.toggle()
                self.active.toggle()
                if self.show {
                    self.activeIndex = index
                }else{
                    self.activeIndex = -1
                }
                //self.activeIndex = index
            }
            
            )
        }
        .frame(height: show ? screen.height : 280)
        .scaleEffect(1 - activeView.height/1000)
        .rotation3DEffect(
            Angle(degrees: Double(self.activeView.height / 10 )),
            axis: (x: 0.0, y: 10.0, z: 0.0)

        )
        .hueRotation(Angle(degrees: Double(self.activeView.height)))
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        .gesture(
            show ?
                DragGesture().onChanged({ (value) in
                    guard value.translation.height < 300 && value.translation.height > 0 else {return}
                    self.activeView = value.translation
                    
                })
                .onEnded({ (value) in
                    if self.activeView.height > 50 {
                        self.show = false
                        self.active = false
                        self.activeIndex = -1
                    }
                    self.activeView = .zero
                }) : nil)
        .edgesIgnoringSafeArea(.all)
        
        

    }
}
func getCardCornerRadius(bounds: GeometryProxy) -> CGFloat {
    if bounds.size.width < 712 && bounds.safeAreaInsets.top < 44 {
        return 0
    }
    
    return 30
}

