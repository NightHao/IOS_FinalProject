//
//  IntoRoomView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import SwiftUI
import UIKit

struct IntoRoomView: View {
    @ObservedObject var roomPW = TextLimit()
    @State var currentUserData: UserData
    @State private var roomNum = ""
    @State private var intoWaitingView: Int? = 0
    @State private var roomAlert = false
    @State private var showPWAlert = false
    @State private var alertMsg = ""
    @State private var searchText = ""
    @State private var roomPassword = ""
    @State private var showAd = false
    @StateObject var roomList = MyRoomList()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var test = ""
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                SearchBar(text: $searchText)
                    .frame(width: 420)
                ScrollView(.vertical) {
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        roomList.updateRoomList()
                    }
                    VStack {
                        ForEach(roomList.roomList.filter({ searchText.isEmpty ? true : $0.id!.contains(searchText) })) { item in
                            Button(action:{
                                findRoom(rn: item.id!)
                            }){
                                RoomRowView(room: item)
                            }
                        }
                    }
                }.coordinateSpace(name: "pullToRefresh")
                .padding()
                NavigationLink(
                    destination: WaitingGameView(currentUserData: currentUserData, roomPW: "", mRN: roomNum), tag: 1, selection: $intoWaitingView){
                    EmptyView()
                }
                Spacer()
                if showAd {
                ADBannerView()
                        .frame(width: 320, height: 40)
                }
             }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
                showAd = true
                }
                roomList.updateRoomList()
            }
            .alert(isPresented: $roomAlert, content: {
                Alert(title: Text(NSLocalizedString("錯誤", comment: "")), message: Text(alertMsg), dismissButton: .cancel())
            })
            .foregroundColor(.black)
            .background(Image("bg2").blur(radius: 10).contrast(0.69))
            .navigationBarTitle(NSLocalizedString("搜尋遊戲房間", comment: ""))
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    func findRoom(rn: String) {
        roomNum = rn
        var findRoom = false
        var fullRoom = false
        var gameStarted = false
        FireBase.shared.fetchRooms { result in
            switch result {
            case .success(let rArray):
                for r in rArray {
                    if r.id! == rn {
                        findRoom = true
                        self.roomPassword = r.roomPassWord
                        if r.user1.userName != "" && r.user0.userName != "" && r.user2.userName != "" && r.user3.userName != "" {
                            fullRoom = true
                        }
                        if r.roomGameStatus {
                            gameStarted = true
                        }
                        break
                    }
                }
                if findRoom == false {
                    alertMsg = NSLocalizedString("找不到該房間，請重新確認房號", comment: "")
                    roomAlert = true
                } else {
                    if gameStarted {
                        alertMsg = NSLocalizedString("房間已開始遊戲，請稍後再試", comment: "")
                        roomAlert = true
                    }
                    else if fullRoom {
                        alertMsg = NSLocalizedString("房間已滿人，請稍後再試", comment: "")
                        roomAlert = true
                    } else {
                        if self.currentUserData.userMoney < 50 {
                            alertMsg = NSLocalizedString("金幣不足!!", comment: "")
                            roomAlert = true
                        } else {
                            if self.roomPassword != "" {
                                alertTextPWView(roomPW: self.roomPassword)
                            } else {
                                intoWaitingView = 1
                            }
                        }
                    }
                }
            case .failure(_):
                print("進入失敗請重新嘗試")
            }
        }
    }
    
    func alertTextPWView(roomPW: String) {
        let alert = UIAlertController(title: NSLocalizedString("需要密碼", comment: ""), message: NSLocalizedString("輸入房間密碼", comment: ""), preferredStyle: .alert)
        alert.addTextField { (pass) in
            pass.isSecureTextEntry = false
            pass.placeholder = NSLocalizedString("房間密碼", comment: "")
            pass.keyboardType = .numberPad
        }
        let intoRoom = UIAlertAction(title: NSLocalizedString("進入", comment: ""), style: .default) { (_) in
            if alert.textFields![0].text == roomPW {
                intoWaitingView = 1
            } else {
                alertErrPW(title: NSLocalizedString("錯誤", comment: ""), message: NSLocalizedString("密碼錯誤", comment: ""))
            }
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .destructive) { (_) in
            
        }
        
        alert.addAction(cancel)
        alert.addAction(intoRoom)
        
        let viewController = UIViewController.getLastPresentedViewController()
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func alertErrPW(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("重新輸入", comment: ""), style: .destructive) { (action: UIAlertAction) in
            alertTextPWView(roomPW: self.roomPassword)
        }
        alertVC.addAction(okAction)
        
        let viewController = UIViewController.getLastPresentedViewController()
        viewController?.present(alertVC, animated: true, completion: nil)
    }
}

struct IntoRoomView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IntoRoomView(currentUserData: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""))
        }
    }
}

//struct TextPWView: View {
//    @ObservedObject var roomPW = TextLimit()
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading) {
//                Text("輸入房間密碼")
//                    .bold()
//                    .font(.title)
//                TextField("", text: $roomPW.userInput)
//                    .keyboardType(.numberPad)
//                    .foregroundColor(midNightBlue)
//                    .padding(10)
//                    .background(Color.yellow)
//                    .opacity(0.8)
//                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            .stroke(midNightBlue, lineWidth: 3)
//                    ).padding(.vertical)
//                HStack {
//                    Spacer()
//                    Button(action:{}){
//                        Text("確認")
//                            .font(.title3)
//                            .bold()
//                            .foregroundColor(midNightBlue)
//                            .padding(.horizontal, 15)
//                            .padding(.vertical, 8)
//                            .background(Color.yellow)
//                            .cornerRadius(10)
//                            .padding(2)
//                            .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(midNightBlue, lineWidth: 3)
//                            )
//                    }
//                }
//            }.padding()
//        }.background(Color.yellow)
//        .frame(width: 350)
//        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .stroke(midNightBlue, lineWidth: 3)
//        ).padding()
//    }
//}

extension UIViewController {
    static func getLastPresentedViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first {
            $0.isKeyWindow
        }
        var presentedViewController = window?.rootViewController
        while presentedViewController?.presentedViewController != nil {
            presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
}

