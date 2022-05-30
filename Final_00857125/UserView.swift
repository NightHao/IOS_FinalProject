//
//  UserView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/28.
//

import SwiftUI
import Kingfisher
import FirebaseAuth
import AppTrackingTransparency

struct UserView: View {
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    @StateObject var myUserData = MyUserData()
    @State private var showContentView = false
    @State private var showCgUserNameView = false
    @State private var showSettingView = false
    @State private var showAlert = false
    @State private var animationOffset:CGFloat = 40
    @State private var animationOpacity:Double = 0
    @State private var gotoWGView = false
    @State private var userBGNum = 0
    @State private var userUID = "*********************"
    @State private var buttonText = NSLocalizedString("顯示", comment: "")
    @State private var roomNum = "0"
    @State private var roomPW = ""
    @State var selectLangIndex = 0
    var midNightBlue = Color(red: 58/255, green: 69/255, blue: 79/255)
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                //ScrollView {
                    HStack {
                        VStack{
                            Spacer()
                            NavigationLink(
                                destination: SettingView(myUserData: self.myUserData, selectLangIndex: self.$selectLangIndex)){
                                Image(systemName: "gearshape")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .background(Color.black.blur(radius: 10.0))
                            }
                        }.padding([.leading, .bottom], 35)
                        Spacer()
                        ImageView(withURL: myUserData.currentUserData.userPhotoURL)
                            .scaledToFit()
                            .frame(width: 120, height: 150)
                            .padding(70)
                        
                        /*if myUserData.currentUserData.userPhotoURL != "" {
                            ImageView(withURL: myUserData.currentUserData.userPhotoURL)
                                .scaledToFit()
                                .frame(width: 120, height: 150)
                                .padding(70)
                        } else {
                            ZStack {
                                Image("body_0")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 150)
                                    .padding(70)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(1.5)
                                    .offset(y: -20)
                            }
                        }*/
                        Spacer()
                        VStack{
                            Spacer()
                            Button(action:{
                                self.userBGNum = Int.random(in: 0...3)
                            }){
                                Image(systemName: "photo.on.rectangle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .background(Color.black.blur(radius: 10.0))
                            }
                        }.padding([.trailing, .bottom,], 35)
                    }.background(
                        Image("userbg" + String(userBGNum))
                            .resizable()
                            .frame(width: 380, height: 220)
                            .cornerRadius(20)
                            .scaledToFill()
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(midNightBlue, lineWidth: 5))
                            )
                    .padding([.top, .horizontal])
                    //基本資料
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        if myUserData.currentUser?.displayName != nil {
                            Text(NSLocalizedString("暱稱: ", comment: "") + (myUserData.currentUserData.userName))
                        } else {
                            Text("暱稱錯誤")
                        }
                        Spacer()
                       
                    }.padding(.top,10)
                    .padding(.horizontal)
                    .padding(.vertical,2)
                    HStack {
                        Image(systemName: "gamecontroller")
                            .frame(width: 25)
                        Text(NSLocalizedString("勝場: ", comment: "") + String(myUserData.currentUserData.userWin))
                        Spacer()
                        Text(NSLocalizedString("敗場: ", comment: "") + String(myUserData.currentUserData.userLose))
                        Spacer()
                        if myUserData.currentUserData.userWin == 0 {
                            Text("勝率: 0%")
                        } else {
                            Text("勝率: ") + Text("\((Double(myUserData.currentUserData.userWin) / Double(myUserData.currentUserData.userWin + myUserData.currentUserData.userLose) * 100), specifier: "%.2f")") + Text("%")
                        }
                    }.padding(.horizontal)
                    .padding(.vertical,2)
                    Group {
                        UserDataView(dataIconStr: "envelope", dataInfo: "Email", data: (myUserData.currentUser?.email)!)
                        HStack{
                            Image(systemName: "dollarsign.circle")
                                .frame(width: 25)
                            Text(NSLocalizedString("金幣", comment: "") + ": " + String(myUserData.currentUserData.userMoney))
                            /*if self.myRewardAD.showAnimation {
                                HStack {
                                    Image(systemName: "dollarsign.circle")
                                    Text("+10")
                                        .bold()
                                }.offset(y: self.animationOffset)
                                .foregroundColor(.red)
                                .opacity(self.animationOpacity)
                                .padding(.horizontal)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                        self.animationOffset -= 40
                                        self.animationOpacity += 1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                        self.animationOpacity -= 1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.myRewardAD.showAnimation = false
                                            self.animationOffset += 40
                                        }
                                    }
                                }
                                .animation(.easeInOut(duration: 1.5))
                            }*/
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical,2)
                        UserDataView(dataIconStr: "g.circle", dataInfo: NSLocalizedString("性別", comment: ""), data: myUserData.currentUserData.userGender)
                        UserDataView(dataIconStr: "calendar", dataInfo: NSLocalizedString("生日", comment: ""), data: myUserData.currentUserData.userBD)
                        UserDataView(dataIconStr: "globe", dataInfo: NSLocalizedString("國家", comment: ""), data:  myUserData.currentUserData.userCountry)
                        UserDataView(dataIconStr: "clock", dataInfo: NSLocalizedString("首次登入", comment: ""), data: myUserData.currentUserData.userFirstLogin)
                        HStack{
                            Image(systemName: "face.smiling")
                            Text("UID: " + userUID)
                            Spacer()
                            Button(action:{
                                if userUID == "*********************" {
                                    userUID =  myUserData.currentUser!.uid
                                    buttonText = NSLocalizedString("隱藏", comment: "")
                                } else {
                                    userUID = "*********************"
                                    buttonText = NSLocalizedString("顯示", comment: "")
                                }
                            }){
                                Text(buttonText)
                            }
                        }.padding(.horizontal)
                        .padding(.vertical,2)
                        .padding(.bottom, 10)
                    }
                }.background(Color.blue)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(midNightBlue, lineWidth: 10))
                .cornerRadius(20)
                    
                    
                //}
                .font(.title3)
                .foregroundColor(midNightBlue)
                .padding()
                
        }
            .background(Image("bg2").blur(radius: 10).contrast(0.69))
            .onAppear{
                self.catchUserData()
                self.catchAPPLang()
                //self.myRewardAD.loadAD()
            }.navigationTitle(NSLocalizedString("個人資料", comment: ""))
            .navigationBarItems(trailing: Button(action:{
                myUserData.removeUserListener()
                FireBase.shared.userSingOut()
                self.presentationMode.wrappedValue.dismiss()
            }){
                HStack{
                    Image(systemName: "figure.walk")
                    Text("登出")
                }.font(.title3)
                .foregroundColor(.red)
            })
    }.accentColor(midNightBlue)
}
    
    private func catchUserData() -> Void {
        FireBase.shared.fetchUsers(){ result in
            switch (result) {
            case .success(let usersArray):
                for u in usersArray {
                    if u.id == myUserData.currentUser?.uid {
                        myUserData.currentUserData = u
                        myUserData.addUserListener()
                        break
                    }
                }
            case .failure(_):
                print("抓取失敗，找不到使用者資料")
            }
        }
    }
    
    /*private func reportAlert(title: String, msg: String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("好", comment: ""), style: .destructive) { (_) in
            
        }
        
        alert.addAction(ok)
        
        let viewController = UIViewController.getLastPresentedViewController()
        viewController?.present(alert, animated: true, completion: nil)
        
    }*/
    
    
    private func catchAPPLang() {
        if String(Locale.preferredLanguages[0].prefix(5)) == "zh" {
            selectLangIndex = 1
        } else if String(Locale.preferredLanguages[0].prefix(5)) == "en" {
            selectLangIndex = 2
        } else {
            selectLangIndex = 0
        }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

