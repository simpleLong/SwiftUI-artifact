//
//  AlgorithmCourseSection.swift
//  iOS-learning-artifact
//
//  Created by 龙晓东 on 2020/9/16.
//

import SwiftUI


struct AlgorithmCourseSection: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var logo: String
    var color: Color
}
var alCourseSections = [
    AlgorithmCourseSection(
        title: "SwiftUI for iOS 14",
        subtitle: "Build a multi-platform app for iOS, iPadOS and Big Sur",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.1776223481, green: 0.003123702249, blue: 0.9679456353, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "SwiftUI Visual Editor",
        subtitle: "Learn Xcode 12's new visual editing and inspector tools",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.4163374901, green: 0, blue: 0.9587711692, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "SF Symbols and List Styles",
        subtitle: "Using SF Symbols 2 and the new list styles in iOS 14",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.5358095765, green: 0.006698517594, blue: 0.9496632218, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Sidebar and Label",
        subtitle: "Setting up a sidebar navigation for iOS 14 and macOS",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.6299541593, green: 0.0007464740775, blue: 0.9487422109, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Card UI and Static Data",
        subtitle: "Create a card layout and make it loop with basic data",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.6941550374, green: 0, blue: 0.9111183882, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Show View and Transitions",
        subtitle: "How to transition between views using preset animations",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.7368183136, green: 0, blue: 0.865359962, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Matched Geometry Effect",
        subtitle: "Magically transition between views matching similar elements",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.8180006742, green: 0.002616824117, blue: 0.8187212348, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Array States and Index",
        subtitle: "How to create unique card animations with changeable states",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.8607265353, green: 0.002661613282, blue: 0.7145370841, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Adaptive and Flexible Lazy Grid",
        subtitle: "Working with iOS 14 grid layout with auto-fit options",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.8991689086, green: 0.006000946742, blue: 0.6428537369, alpha: 1))
    ),
    AlgorithmCourseSection(
        title: "Animation Delay and zIndex",
        subtitle: "Setting Cards above others and animating with delay",
        logo: "Logo SwiftUI",
        color: Color(#colorLiteral(red: 0.9505215287, green: 0.0005362218362, blue: 0.5361744165, alpha: 1))
    ),
]
