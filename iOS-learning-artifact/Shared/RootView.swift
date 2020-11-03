//
//  RootView.swift
//  iOS-learning-artifact
//
//  Created by 龙晓东 on 2020/9/16.
//

import SwiftUI



struct RootView: View {

    var body: some View {
        HomeView(showProfile: .constant(false))

    }
}




struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
