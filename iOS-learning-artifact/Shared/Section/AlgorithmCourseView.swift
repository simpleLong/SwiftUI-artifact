//
//  AlgorithmCourseView.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI

struct AlgorithmCourseView: View {
   // @State var sectionQuestions : [Question]
    var course: Section
   @State var show: Bool = true
  //  var bounds: GeometryProxy
    var body: some View {
        ZStack {
            VStack {
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

                            
                            VStack {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 36, height: 36)
                            .background(Color.black)
                            //.clipShape(Circle())
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
        //        .cornerRadius(25)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.show.toggle()
            })
//                if show {
//                    Text("你是谁").background(Color.red)
//                    Spacer()
//                }
            }

        }.ignoresSafeArea()
        

        
      //  .clipShape(RoundedRectangle(cornerRadius: show ? 60 : 30, style: .continuous))
//            .shadow(color: course.shadowColor.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}
func getCardCornerRadius(bounds: GeometryProxy) -> CGFloat {
    if bounds.size.width < 712 && bounds.safeAreaInsets.top < 44 {
        return 0
    }
    
    return 30
}

struct AlgorithmCourseView_Previews: PreviewProvider {

    static var show: Bool = true
    static let section = Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "stack", image: Image(uiImage: #imageLiteral(resourceName: "StarrySkybg0")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array")
    static var previews: some View {
        AlgorithmCourseView(course: section, show: show)
    }
}
