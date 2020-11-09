//
//  UserStore.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/26.
//

import SwiftUI
import Combine

class UserStore: ObservableObject {
    @Published var isLogged: Bool = CustomUserDefaults.isLoggedIn {
        didSet {
//            UserDefaults.standard.set(self.isLogged, forKey: "isLogged")
            CustomUserDefaults.isLoggedIn = self.isLogged
        }
    }
    @Published var showLogin = false
}

