//
//  ContentView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/28.
//

import SwiftUI
import FirebaseAuth
import AVFoundation
import GoogleSignIn
import FacebookLogin
import UIKit
struct ContentView: View {
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        //AVPlayer.setupBgMusic()
        //AVPlayer.bgQueuePlayer.play()
    }
    
    @State private var userEmail = ""
    @State private var userPW = ""
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State private var showView = false
    @State private var returnBool = false
    @State private var showProgressView = false
    @State private var firstIntoView = true
    //@State var looper: AVPlayerLooper?
    @State private var showFLView = false
    @State private var myAlert = Alert(title: Text(""))
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
        VStack {
            VStack{
                Text("ððð°ðð ðð¿")
                    .font(.custom("SanafonMaru", size: 50))
                    .foregroundColor(.black)
                Text("å¤§å¯ç¿")
                    .font(.custom("SanafonMaru", size: 40))
                    .foregroundColor(.black)
            }
                Spacer()
                Group{
                    CustomTextField(
                        placeholder: Text("ä½¿ç¨èEmail(å¸³è)").foregroundColor(midNightBlue),
                        text: $userEmail, secure: false, isEmail: true
                    )
                    CustomTextField(
                        placeholder: Text("ä½¿ç¨èå¯ç¢¼").foregroundColor(midNightBlue),
                        text: $userPW, secure: true, isEmail: false
                    )
                }.offset(y:-40)
            
                HStack{
                    Button(action:{userLoginAction()}){
                        ButtonView(buttonText: NSLocalizedString("ç»å¥", comment: ""))
                    }
                    .padding(5)
                    NavigationLink(
                        destination: RegisterView()){
                        ButtonView(buttonText: NSLocalizedString("è¨»å", comment: ""))
                    }
                    .padding(5)
                }.padding(.top, 5)
                .fullScreenCover(isPresented: $returnBool)
                    { UserView()}
                .padding(.top, 5)
                Spacer()
            /*Button("Crash") {
              fatalError("Crash was triggered")
            }*/
                Button {
                        let manager = LoginManager()
                        manager.logIn(permissions: [.publicProfile, .email]) { result in
                             switch result {
                             case .success(granted: let granted, declined: let declined, token: let token):
                                  print("success")
                                 let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
                                 request.start { response, result, error in
                                    if let result = result as? [String:String] {
                                       print(result)
                                        userEmail = result["email"]! ?? ""
                                        userPW = "ntountou"
                                        userLoginAction()
                                        if returnBool == false{
                                            print("H1")
                                            FireBase.shared.createUser(userEmail: userEmail, pw: userPW) {
                                                (result) in
                                                switch result {
                                                case .success( _):
                                                    go2FirstLoginView()
                                                case .failure(_):
                                                    break
                                                }
                                            }
                                            }
                                        }
                                    }
                             case .cancelled:
                                  print("cancelled")
                             case .failed(_):
                                  print("failed")
                             }
                        }
                    } label: {
                        Text("Facebook Login").foregroundColor(.purple)
                    }
                

            }.offset(y: -20)
            /*.navigationBarItems(trailing:
                Button(action:{
                    if myPlayer.timeControlStatus == .playing {
                        myPlayer.pause()
                    }
                    else {
                        myPlayer.play()
                    }
                }){
                    HStack {
                        Text("Music")
                        Image(systemName: "play.circle.fill")
                    }.font(.title3)
                    .foregroundColor(midNightBlue)
            })*/
            .onTapGesture {
                self.endEditing()
            }
            .background(
                Image("bg")
                    .contrast(0.8)
            )
            .fullScreenCover(isPresented: $showFLView, content: {
                FirstLoginView(userEmail: userEmail, userPW: userPW)
            })
            .onAppear{
                self.returnBool = false
                //self.playMusic()
                for code in NSLocale.isoCountryCodes as [String] {
                    let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
                    let name = NSLocale(localeIdentifier: "zh_TW").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
                    countries.append(name)
                }
                if Auth.auth().currentUser != nil {
                    self.showProgressView = true
                    userLoggedIn()
                }
            }
            .foregroundColor(.primary)
            .alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text("é¯èª¤"), message: Text(alertMsg),  dismissButton: .default(Text("éæ°è¼¸å¥")))
            }
        }
    }
    
    private func userLoginAction() {
        FireBase.shared.userSignIn(userEmail: userEmail, pw: userPW){
            (result) in
            switch result {
            case .success( _):
                if let user = Auth.auth().currentUser {
                    print("\(user.uid) ç»å¥æå")
                    FireBase.shared.fetchUsers(){
                        (result) in
                        switch result {
                        case .success(let udArray):
                            print("ä½¿ç¨èè³ææåæå")
                            for u in udArray {
                                if u.id == user.uid {
                                    showView = true
                                    returnBool = true
                                    print("ææé²ä¾")
                                }
                            }
                            
                        case .failure(_):
                            print("ä½¿ç¨èè³ææåå¤±æ")
                            returnBool = false
                            //showView = true
                        }
                    }
                } else {
                    print("ç»å¥å¤±æ")
                }
            case .failure(let errormsg):
                switch errormsg {
                case .pwInvalid:
                    alertMsg = "å¯ç¢¼é¯èª¤"
                    showAlert = true
                case .noAccount:
                    alertMsg = "å¸³èä¸å­å¨ï¼è«è¨»åæä½¿ç¨å¶ä»å¸³è"
                    showAlert = true
                case .others:
                    alertMsg = "ä¸æåå é¯èª¤ï¼è«éæ°ç»å¥"
                    showAlert = true
                }
            }
        }
    }
    
    private func userLoggedIn() {
        FireBase.shared.fetchUsers(){
            (result) in
            switch result {
            case .success(let udArray):
                print("ä½¿ç¨èè³ææåæå")
                for u in udArray {
                    if u.id == Auth.auth().currentUser?.uid {
                        returnBool = true
                        print("ææé²ä¾")
                    }
                }
                showProgressView = false
                showView = true
                
            case .failure(_):
                print("ä½¿ç¨èè³ææåå¤±æ")
                showProgressView = false
                returnBool = false
            }
        }
    }

    func go2FirstLoginView() -> Void {
        print(Auth.auth().currentUser!.uid)
        self.presentationMode.wrappedValue.dismiss()
        self.showFLView = true
    }
    
    /*private func playMusic() {
        if firstIntoView {
            self.looper = AVPlayerLooper(player: myPlayer, templateItem: item)
            myPlayer.volume = UserDefaults.standard.object(forKey: "myPlayerVol") as? Float ?? 0.1
            if UserDefaults.standard.object(forKey: "myPlayerStatus") as? Bool ?? true {
                myPlayer.play()
            }
            firstIntoView = false
        }
    }*/
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



/*
 HStack{
     Button(action:{userLoginAction()}){
         ButtonView(buttonText: "ç»å¥")
     }
     .padding(5)
     NavigationLink(
         destination: RegisterView()){
         ButtonView(buttonText: "è¨»å")
     }
     .padding(5)
 }.padding(.top, 5)
 .fullScreenCover(isPresented: $showView)
     { UserView()}
 */
