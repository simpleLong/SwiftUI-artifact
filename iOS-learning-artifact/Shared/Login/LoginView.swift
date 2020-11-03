//
//  LoginView.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/26.
//

import SwiftUI


struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isFocused = false
    @State var showAlert = false
    @State var alertMessage = "Something went wrong."
    @State var isLoading = false
    @State var isSuccessful = false
    @EnvironmentObject var user: UserStore
    var updateQuestionsBlock :  (Bool) -> ()
    
    
    
    func login() {
        self.hideKeyboard()
        self.isFocused = false
        self.isLoading = true
        
        Api().login(account: email, password: password) { isLoginSuccess in

            updateQuestionsBlock(isLoginSuccess)

            self.isLoading = false

            if isLoginSuccess == false {
               
                self.showAlert = true
            } else {


                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isSuccessful = true
                    self.user.isLogged = true
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    UserDefaults.standard.setValue(email, forKey: "account")
                    self.email = ""
                    self.password = ""
                    self.isSuccessful = false
                    self.user.showLogin = false
                }
            }
        }
        

        
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in

//        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .top) {
                
                Color("background2")
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .edgesIgnoringSafeArea(.bottom)
                
                CoverView()
                    .offset(y: isFocused ? -150 : 0)
                
                VStack {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color("background1"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                        
                        TextField("Your Email".uppercased(), text: $email)
                            .keyboardType(.emailAddress)
                            .font(.subheadline)
        //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture {
                                self.isFocused = true
                        }
                    }
                    
                    Divider().padding(.leading, 80)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                            .frame(width: 44, height: 44)
                            .background(Color("background1"))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                            .padding(.leading)
                        
                        SecureField("Password".uppercased(), text: $password)
                            .keyboardType(.default)
                            .font(.subheadline)
                            //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                            .frame(height: 44)
                            .onTapGesture {
                                self.isFocused = true
                        }
                    }
                }
                .frame(height: 136)
                .frame(maxWidth: 712)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                .padding(.horizontal)
                .offset(y: 460)
                .offset(y: isFocused ? -150 : 0)
                
                HStack {
                    Text("Forgot password?")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button(action: {
                        self.login()
                    }) {
                        Text("Log in").foregroundColor(.black)
                    }
                    .padding(12)
                    .padding(.horizontal, 30)
                    .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)).opacity(0.3), radius: 20, x: 0, y: 20)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding()
                
            }
            
            .animation(isFocused ? .easeInOut : nil)
            .onTapGesture {
                self.isFocused = false
                self.hideKeyboard()
            }
            
            if isLoading {
                LoadingView()
            }
            
            if isSuccessful {
                LoginSuccessView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(updateQuestionsBlock: { isSuccess  in
            
        })
//        .previewDevice("iPad Air 2")
    }
}

struct CoverView: View {
    @State var show = false
    @State var viewState = CGSize.zero
    @State var isDragging = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Text("请登录leetcode中国的账号密码")
                    .font(.system(size: geometry.size.width/10, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 375, maxHeight: 100)
            .padding(.horizontal, 16)
            .offset(x: viewState.width/15, y: viewState.height/15)
            
            Text("目前只支持账号密码登录")
                .font(.subheadline)
                .frame(width: 250)
                .offset(x: viewState.width/20, y: viewState.height/20)
            
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.top, 100)
        .frame(height: 477)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(uiImage: #imageLiteral(resourceName: "star"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .offset(x: -100, y: -150)
                    
                    .rotationEffect(Angle(degrees: show ? 360+90 : 90))
                    .blendMode(.plusDarker)
                    .animation(Animation.linear(duration: 30).repeatForever(autoreverses: false))
//                    .animation(nil)
                    .onAppear { self.show = true }
                
                Image(uiImage: #imageLiteral(resourceName: "star1"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .offset(x: -50, y: -100)
                    .rotationEffect(Angle(degrees: show ? 360 : 0), anchor: .leading)
                    .blendMode(.overlay)
                    .animation(Animation.linear(duration: 45).repeatForever(autoreverses: false))
                
                Image(uiImage: #imageLiteral(resourceName: "star2"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .offset(x: 200, y: 150)
                    .rotationEffect(Angle(degrees: show ? 360 : 0), anchor: .trailing)
                    .blendMode(.overlay)
                    .animation(Animation.linear(duration: 60).repeatForever(autoreverses: false))
                
                Image(uiImage: #imageLiteral(resourceName: "spaceman"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .offset(x: 50, y: 100)
                    .rotationEffect(Angle(degrees: show ? 360 : 0), anchor: .center)
                    .blendMode(.overlay)
                    .animation(Animation.linear(duration: 60).repeatForever(autoreverses: false))
//                    .animation(nil)
            }
        )
//            .background(
//                Image(uiImage: #imageLiteral(resourceName: "outerspace"))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .offset(x: viewState.width/25, y: viewState.height/25)
//                , alignment: .bottom
//        )
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.0008350018761, green: 0.1427796483, blue: 0.4610896707, alpha: 1)), Color(#colorLiteral(red: 0.04084359854, green: 0.6312003732, blue: 0.9676688313, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .scaleEffect(isDragging ? 0.9 : 1)
            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
            .rotation3DEffect(Angle(degrees: 5), axis: (x: viewState.width, y: viewState.height, z: 0))
            .gesture(
                DragGesture().onChanged { value in
                    self.viewState = value.translation
                    self.isDragging = true
                }
                .onEnded { value in
                    self.viewState = .zero
                    self.isDragging = false
                }
        )
    }
}

