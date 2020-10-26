//
//  LottieLoadingView.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/26.
//

import SwiftUI
import Lottie
struct LottieView: UIViewRepresentable {

    var filename: String
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(filename: "loading")
    }
}
