//
//  SectionView.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI
struct GradientModel: Identifiable {
    var id = UUID()
    var color1: Color
    var color2: Color
}

let gradients = [
    GradientModel(color1: Color(#colorLiteral(red: 1, green: 0.6909791827, blue: 0.4657924175, alpha: 1)), color2: Color(#colorLiteral(red: 0.9987686276, green: 0.3749506474, blue: 0.2407735586, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.4531330466, green: 0.8117174506, blue: 0.8803752065, alpha: 1)), color2: Color(#colorLiteral(red: 0.09379924089, green: 0.1368356943, blue: 0.6082749963, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.7728325725, green: 0.8862304091, blue: 0.853720665, alpha: 1)), color2: Color(#colorLiteral(red: 0.3958079219, green: 0.6382761002, blue: 0.5782583356, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.9978998303, green: 0.6179021001, blue: 0.6138569713, alpha: 1)), color2: Color(#colorLiteral(red: 0.7467702031, green: 0.148047626, blue: 0.1619547009, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.94892627, green: 0.949085176, blue: 0.9489052892, alpha: 1)), color2: Color(#colorLiteral(red: 0.8907456994, green: 0.8661559224, blue: 0.8445791602, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.02114811912, green: 0.3118172884, blue: 0.4884781837, alpha: 1)), color2: Color(#colorLiteral(red: 0.8487409353, green: 0.9371084571, blue: 0.8523408771, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.2414012253, green: 0.2302930355, blue: 0.2824186981, alpha: 1)), color2: Color(#colorLiteral(red: 0.08647771925, green: 0.08583382517, blue: 0.1160869971, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.7015507221, green: 0.7048246861, blue: 0.7957283854, alpha: 1)), color2: Color(#colorLiteral(red: 0.188051492, green: 0.2106980681, blue: 0.3219686747, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.8997144103, green: 0.8901990056, blue: 0.8683555722, alpha: 1)), color2: Color(#colorLiteral(red: 0.8172894716, green: 0.6693791747, blue: 0.6370381713, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.6881515384, green: 0.7947167158, blue: 0.8492486477, alpha: 1)), color2: Color(#colorLiteral(red: 0.2248462439, green: 0.28623721, blue: 0.6949500442, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.8833560348, green: 0.9562644362, blue: 0.8717114925, alpha: 1)), color2: Color(#colorLiteral(red: 0.3151327968, green: 0.5927541852, blue: 0.4170747697, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.9978998303, green: 0.6179021001, blue: 0.6138569713, alpha: 1)), color2: Color(#colorLiteral(red: 0.8575046659, green: 0.2745615244, blue: 0.2356874347, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.9887832999, green: 0.9642031789, blue: 0.9426122308, alpha: 1)), color2: Color(#colorLiteral(red: 0.9997577071, green: 0.4739788771, blue: 0.2949653268, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.6147409081, green: 0.5990688801, blue: 0.6340571046, alpha: 1)), color2: Color(#colorLiteral(red: 0.1462198496, green: 0.1405853033, blue: 0.1709947586, alpha: 1)))
]

struct Section: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var logo: String
    var image: Image
    var color: LinearGradient
    var shadowColor :Color
    var show :Bool = false
    var topicTag :String
    
    
}
struct SectionView: View {
    var section: Section
    var width: CGFloat = 275
    var height: CGFloat = 275
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 160, alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                Image(section.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            }
            
            Text(section.subtitle.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 210)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: width, height: height)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.shadowColor.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

struct SectionView_Previews: PreviewProvider {
    static let section = Section(title: "Build a SwiftUI app", subtitle: "20 Sections", logo: "Stack", image: Image(uiImage: #imageLiteral(resourceName: "Background1")), color: LinearGradient(gradient: Gradient(colors: [gradients[1].color1, gradients[1].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[0].color2, topicTag: "Array")
    static var previews: some View {
        SectionView(section: section)
    }
}
