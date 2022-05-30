//
//  RegisterView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/28.
//

import SwiftUI
import FirebaseAuth

struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}

struct RegisterView: View {
    
    //修改NavigationBarTitle字體顏色
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    @State private var userEmail = ""
    @State private var userPW = ""
    @State private var userCPW = ""
    @State private var userGender = ""
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State private var showFLView = false
    @State private var myAlert = Alert(title: Text(""))
    @State private var selectedIndex = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var gender = ["男", "女"]
    var midNightBlue = Color(red: 58/255, green: 69/255, blue: 79/255)
    var body: some View {
        Background{
        VStack{
            CustomTextField(
                placeholder: Text("使用者Email(帳號)").foregroundColor(midNightBlue),
                text: $userEmail, secure: false, isEmail: true
            )
            CustomTextField(
                placeholder: Text("使用者密碼").foregroundColor(midNightBlue),
                text: $userPW, secure: true, isEmail: false
            )
            HStack {
                CustomTextField(
                    placeholder: Text("確認密碼").foregroundColor(midNightBlue),
                    text: $userCPW, secure: true, isEmail: false
                )
                if userPW != userCPW {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .offset(x:-10)
                } else {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                        .offset(x:-10)
                }
            }
            HStack {
                Button(action:{
                    if userEmail != "" && userPW != ""{
                        if userPW != userCPW {
                            showAlertMsg(msg: NSLocalizedString("兩次密碼不一致", comment: ""))
                        } else {
                            FireBase.shared.createUser(userEmail: userEmail, pw: userPW) {
                                (result) in
                                switch result {
                                case .success( _):
                                    showAlertMsg(msg: NSLocalizedString("註冊成功", comment: ""))
                                case .failure(let errormsg):
                                    print("註冊失敗")
                                    switch errormsg {
                                    case .emailFormat:
                                        showAlertMsg(msg: NSLocalizedString("電子郵件格式不正確", comment: ""))
                                    case .emailUsed:
                                        showAlertMsg(msg: NSLocalizedString("電子郵件已被註冊", comment: ""))
                                    case .pwtooShort:
                                        showAlertMsg(msg: NSLocalizedString("密碼長度需至少大於6", comment: ""))
                                    case .others:
                                        showAlertMsg(msg: NSLocalizedString("不明原因錯誤，請重新註冊", comment: ""))
                                    }
                                    break
                                }
                            }
                        }
                    }
                    else {
                        showAlertMsg(msg: NSLocalizedString("帳號或密碼不得為空", comment: ""))
                    }
                }){
                    ButtonView(buttonText: NSLocalizedString("送出", comment: ""))
                }.alert(isPresented: $showAlert) { () -> Alert in
                    return myAlert
                }
            }.padding()
        }
        .background(
            Image("bg")
                .blur(radius: 10)
                .contrast(0.8)
        )
        .fullScreenCover(isPresented: $showFLView, content: {
            FirstLoginView(userEmail: userEmail, userPW: userPW)
        })
        .padding()
        .navigationTitle(NSLocalizedString("註冊", comment: ""))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action:{self.presentationMode.wrappedValue.dismiss()}){
            HStack {
                Image(systemName: "chevron.left")
                Text("返回")
            }.foregroundColor(.black)
        })
        }.onTapGesture {
            self.endEditing()
        }
    }
    
    func go2FirstLoginView() -> Void {
        print(Auth.auth().currentUser!.uid)
        self.presentationMode.wrappedValue.dismiss()
        self.showFLView = true
    }
    
    func showAlertMsg(msg: String) -> Void {
        self.alertMsg = msg
        if alertMsg == NSLocalizedString("註冊成功", comment: "") {
            self.myAlert = Alert(title: Text(NSLocalizedString("成功", comment: "")), message: Text(alertMsg), dismissButton: .cancel(Text(NSLocalizedString("前往設置個人資料", comment: "")), action:go2FirstLoginView))
            //
            self.showAlert = true
        }
        else {
            self.myAlert = Alert(title: Text(NSLocalizedString("錯誤", comment: "")), message: Text(alertMsg), dismissButton: .cancel(Text(NSLocalizedString("重新輸入", comment: ""))))
            self.showAlert = true
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
 
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
