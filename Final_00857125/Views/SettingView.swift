//
//  SettingView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/29.
//

import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @State var myUserData: MyUserData
    @Binding var selectLangIndex: Int
    @State private var ogLangIndex = 0
    @State private var playingMusic = UserDefaults.standard.object(forKey: "myPlayerStatus") as? Bool ?? true
    @State private var showGameRule = false
    @State private var musicVolSlider: CGFloat = CGFloat(UserDefaults.standard.object(forKey: "myPlayerVol") as? Float ?? 0.1)
    @State private var langArr = ["繁體中文", "简体中文", "English"]
    @State private var showRestartAlert = false
    
    var body: some View{
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("帳號設定")
                            .font(.title)
                            .bold()
                        HStack {
                            Button(action:{self.changeUserName()}) {
                                Text("修改暱稱")
                                    .font(.title2)
                            }
                            Spacer()
                        }.padding(.vertical, 5)
                        HStack {
                            Button(action:{self.changeUserPW()}) {
                                Text("修改密碼")
                                    .font(.title2)
                            }
                            Spacer()
                        }.padding(.bottom, 5)
                    }.padding()
                }.foregroundColor(midNightBlue)
                .background(Color.blue)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(midNightBlue, lineWidth: 10))
                .cornerRadius(20)
                /*VStack {
                    VStack(alignment: .leading) {
                        Text("音樂設定")
                            .font(.title)
                            .bold()
                        Toggle("音樂", isOn: $playingMusic)
                            .font(.title2)
                            .toggleStyle(SwitchToggleStyle(tint: midNightBlue))
                            .onChange(of: playingMusic, perform: { value in
                                if value {
                                    myPlayer.play()
                                } else {
                                    myPlayer.pause()
                                }
                                UserDefaults.standard.set(value, forKey: "myPlayerStatus")
                            })
                        HStack {
                            Text("音量")
                                .font(.title2)
                            Slider(value: $musicVolSlider, in: 0...1, step: 0.1)
                                .accentColor(midNightBlue)
                                .onChange(of: musicVolSlider, perform: { _ in
                                    myPlayer.volume = Float(musicVolSlider)
                                    UserDefaults.standard.set(musicVolSlider, forKey: "myPlayerVol")
                                })
                        }
                    }.padding()
                    
                }.foregroundColor(midNightBlue)
                .background(Color.blue)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(midNightBlue, lineWidth: 10))
                .cornerRadius(20)*/
                VStack {
                    VStack(alignment: .leading) {
                        Text("語言設定")
                            .font(.title)
                            .bold()
                        if self.showRestartAlert {
                            Text("更換語言需要重新啟動APP")
                                .font(.system(size: 14))
                                .bold()
                                .foregroundColor(.red)
                        }
                        Picker(selection: $selectLangIndex, label: Text("選擇語言")) {
                            ForEach(langArr.indices) { (index) in
                               Text(langArr[index])
                            }
                         }.font(.title2)
                        .foregroundColor(midNightBlue)
                        .pickerStyle(SegmentedPickerStyle())
                        .onAppear {
                            customSegmentStyle()
                        }
                        .onChange(of: selectLangIndex, perform: { _ in
                            if selectLangIndex == 0 {
                                UserDefaults.standard.set(["zh_TW"], forKey: "AppleLanguages")
                            } else if selectLangIndex == 1 {
                                UserDefaults.standard.set(["zh"], forKey: "AppleLanguages")
                            } else {
                                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                            }
                            print("使用者選擇了: " + langArr[selectLangIndex])
                            if self.selectLangIndex == self.ogLangIndex {
                                self.showRestartAlert = false
                            } else {
                                self.showRestartAlert = true
                            }
                            UserDefaults.standard.synchronize()
                        })
                    }.padding()
                }.foregroundColor(midNightBlue)
                .background(Color.blue)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(midNightBlue, lineWidth: 10))
                .cornerRadius(20)
                VStack {
                    VStack(alignment: .leading) {
                        Text("其他")
                            .font(.title)
                            .bold()
                        HStack {
                            Button(action:{self.showGameRule = true}) {
                                Text("遊戲規則/策略 & 金幣說明")
                                    .font(.title2)
                            }.sheet(isPresented: self.$showGameRule, content: {
                                GameRule()
                            })
                            Spacer()
                        }.padding(.vertical, 5)
                        
                    }.padding()
                }.foregroundColor(midNightBlue)
                .background(Color.blue)
                .padding(2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(midNightBlue, lineWidth: 10))
                .cornerRadius(20)
            }.padding()
            .background(Image("bg2").blur(radius: 10).contrast(0.69))
            .navigationTitle(NSLocalizedString("設定", comment: ""))
            .onAppear {
                self.ogLangIndex = self.selectLangIndex
            }
    }
    
    private func customSegmentStyle() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(midNightBlue)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.blue)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(midNightBlue)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(Color.blue)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .title2)], for: .normal)
    }
    
    private func changeUserName() -> Void {
        let alert = UIAlertController(title: NSLocalizedString("修改", comment: ""), message: NSLocalizedString("輸入新的暱稱", comment: ""), preferredStyle: .alert)
        alert.addTextField { (pass) in
            pass.isSecureTextEntry = false
            pass.placeholder = NSLocalizedString("輸入新的暱稱", comment: "")
        }
        let cgun = UIAlertAction(title: NSLocalizedString("修改", comment: ""), style: .default) { (_) in
            if alert.textFields![0].text != "" {
                FireBase.shared.setDBUserName(userID: myUserData.currentUser!.uid, userName: alert.textFields![0].text!){ result in
                    switch (result) {
                    case .success(_):
                        print("修改暱稱成功(DB)")
                        FireBase.shared.setUserDisplayName(userDisplayName: alert.textFields![0].text!)
                        reportAlert(title: NSLocalizedString("成功", comment: ""), msg: NSLocalizedString("修改暱稱成功!", comment: ""))
                    case .failure(_):
                        print("修改暱稱失敗")
                        reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("發生不明錯誤，請稍後再試", comment: ""))
                    }
                }
            } else {
                reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("暱稱不得為空!", comment: ""))
            }
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .destructive) { (_) in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(cgun)
        
        let viewController = UIViewController.getLastPresentedViewController()
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    private func changeUserPW() -> Void {
        let alert = UIAlertController(title: NSLocalizedString("修改", comment: ""), message: NSLocalizedString("輸入舊的&新的密碼", comment: ""), preferredStyle: .alert)
        alert.addTextField { (pass) in
            pass.isSecureTextEntry = true
            pass.placeholder = NSLocalizedString("輸入舊密碼", comment: "")
        }
        alert.addTextField { (pass2) in
            pass2.isSecureTextEntry = true
            pass2.placeholder = NSLocalizedString("輸入新密碼", comment: "")
        }
        let cgpw = UIAlertAction(title: NSLocalizedString("修改", comment: ""), style: .default) { (_) in
            FireBase.shared.userSignIn(userEmail: (myUserData.currentUser?.email)!, pw: alert.textFields![0].text!){
                (result) in
                switch result {
                case .success(_):
                    if Auth.auth().currentUser != nil {
                        print("舊密碼正確")
                        FireBase.shared.setUserPassword(pw: alert.textFields![1].text!){ result in
                            switch (result) {
                            case .success(_):
                                print("修改密碼成功")
                                reportAlert(title: NSLocalizedString("成功", comment: ""), msg: NSLocalizedString("修改密碼成功!", comment: ""))
                            case .failure(_):
                                print("修改密碼失敗")
                                reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("發生不明錯誤，請稍後再試", comment: ""))
                            }
                        }
                    } else {
                        print("登入失敗")
                        reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("發生不明錯誤，請稍後再試", comment: ""))
                    }
                case .failure(let errormsg):
                    switch errormsg {
                    case .pwInvalid:
                        reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("舊密碼錯誤，請重新輸入", comment: ""))
                    case .noAccount:
                        reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("發生不明錯誤，請稍後再試", comment: ""))
                    case .others:
                        reportAlert(title: NSLocalizedString("錯誤", comment: ""), msg: NSLocalizedString("發生不明錯誤，請稍後再試", comment: ""))
                    }
                }
            }
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .destructive) { (_) in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(cgpw)
        
        let viewController = UIViewController.getLastPresentedViewController()
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    private func reportAlert(title: String, msg: String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("好", comment: ""), style: .destructive) { (_) in
            
        }
        
        alert.addAction(ok)
        
        let viewController = UIViewController.getLastPresentedViewController()
        viewController?.present(alert, animated: true, completion: nil)
        
    }
}
