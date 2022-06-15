//
//  WaitingGameView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import SwiftUI
import Kingfisher
import URLImage
import Firebase

struct WaitingGameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var currentUserData: UserData
    @State var roomPW: String
    @State private var titleText = ""
    @State private var showText = false
    @State private var userNum = -1
    @State private var notReadyAlert = false
    @State private var showHostLeft = false
    @State var gotoGameView = false
    @State var map = false
    @State private var secUserData = UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: "")
    @State private var thirdUserData = UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: "")
    @State private var fourthUserData = UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: "")
    @StateObject var myRoomData = MyRoom()
    var mRN: String
    var body: some View {
        Background {
            VStack {
                VStack(alignment: .leading) {
                    if myRoomData.roomData.roomPassWord != "" {
                         HStack {
                             Image(systemName: "lock")
                             Text(NSLocalizedString("密碼: ", comment: "") + myRoomData.roomData.roomPassWord)
                             Spacer()
                         }.offset(x:13, y:20)
                    }
                }.font(.title2)
                HStack {
                    VStack{
                        HStack {
                            Image(systemName: "crown")
                            Text("主持人")
                                .bold()
                        }.font(.system(size: 22))
                    }.foregroundColor(.black)
                    .frame(width: 130, height: 40)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .cornerRadius(10)
                    VStack {
                        if myRoomData.roomData.user1.userName != "" {
                            if myRoomData.roomData.user1ready {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("準備")
                                        .bold()
                                }.font(.system(size: 22))
                            } else {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("尚未準備")
                                        .bold()
                                }.font(.system(size: 22))
                            }
                        }
                    }.foregroundColor(.black)
                    .frame(width: 130, height: 40)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .cornerRadius(10)
                }.offset(y:10)
                HStack {
                    VStack {
                        Text(myRoomData.roomData.user0.userName)
                            .font(.system(size: 25))
                            .bold()
                            .shadow(radius: 10)
                            .padding(.bottom, 20)
                        if myRoomData.roomData.user0.userPhotoURL != "" {
                            ImageView(withURL: myRoomData.roomData.user0.userPhotoURL)
                                //.resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 180)
                                .shadow(radius: 20.0)
                        }
                    
                    }.frame(width: 90, height: 200)
                    .padding()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    Spacer()
                    VStack {
                        Text(myRoomData.roomData.user1.userName)
                            .font(.system(size: 25))
                            .bold()
                            .shadow(radius: 10)
                            .padding(.bottom, 20)
                        if myRoomData.roomData.user1.userPhotoURL != "" {
                            ImageView(withURL: myRoomData.roomData.user1.userPhotoURL)
                                //.resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 180)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                .shadow(radius: 20.0)
                        }
                    }.frame(width: 90, height: 200)
                    .padding()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                }.padding(5)
                    .offset(y:10)
                HStack {
                    VStack {
                        if myRoomData.roomData.user2.userName != "" {
                            if myRoomData.roomData.user2ready {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("準備")
                                        .bold()
                                }.font(.system(size: 22))
                            } else {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("尚未準備")
                                        .bold()
                                }.font(.system(size: 22))
                            }
                        }
                    }.foregroundColor(.black)
                    .frame(width: 130, height: 40)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .cornerRadius(10)
                    VStack {
                        if myRoomData.roomData.user3.userName != "" {
                            if myRoomData.roomData.user3ready {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("準備")
                                        .bold()
                                }.font(.system(size: 22))
                            } else {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("尚未準備")
                                        .bold()
                                }.font(.system(size: 22))
                            }
                        }
                    }.foregroundColor(.black)
                    .frame(width: 130, height: 40)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                HStack {
                    VStack {
                        Text(myRoomData.roomData.user2.userName)
                            .font(.system(size: 25))
                            .bold()
                            .shadow(radius: 10)
                            .padding(.bottom, 20)
                        if myRoomData.roomData.user2.userPhotoURL != "" {
                            ImageView(withURL: myRoomData.roomData.user2.userPhotoURL)
                                //.resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 180)
                                .shadow(radius: 20.0)
                        }
                    
                    }.frame(width: 90, height: 200)
                    .padding()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    Spacer()
                    VStack {
                        Text(myRoomData.roomData.user3.userName)
                            .font(.system(size: 25))
                            .bold()
                            .shadow(radius: 10)
                            .padding(.bottom, 20)
                        if myRoomData.roomData.user3.userPhotoURL != "" {
                            ImageView(withURL: myRoomData.roomData.user3.userPhotoURL)
                                //.resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 180)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                .shadow(radius: 20.0)
                        }
                    }.frame(width: 90, height: 200)
                    .padding()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                }.padding(5)
                Button("change_map"){
                    if map == false{
                        map = true
                    }
                    else{
                        map = false
                    }
                }
            }.foregroundColor(.black)
            .fullScreenCover(isPresented: $gotoGameView)
            { GameView(gotoGameView: $gotoGameView, map: $map, myRoomData: myRoomData, userNum: userNum, startPlayer: myRoomData.roomData.startPlayer) }
            .onAppear{
                print(self.userNum)
                if mRN == "-1"{
                    self.userNum = 0
                }
                print("mRN:\(userNum)")
                self.myCreatRoom(roomNum: mRN)
            }
            .onReceive(self.myRoomData.secondPlayerInto , perform: { _ in
                print("Second Player Into Room.")
                print("Second\(userNum)")
            })
            .onReceive(self.myRoomData.thirdPlayerInto , perform: { _ in
                print("Third Player Into Room.")
                print("Third\(userNum)")
            })
            .onReceive(self.myRoomData.noThirdPlayer, perform: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
                if self.userNum == -1 && self.myRoomData.roomData.user2.userName == ""{
                    self.userNum = 1
                }
                print("noThird here:\(self.userNum)")
                }
            })
            .onReceive(self.myRoomData.fourthPlayerInto , perform: { _ in
                print("Fourth Player Into Room.")
                print("Fourth\(userNum)")
                if self.userNum == -1{
                    self.userNum = 3
                }
                print("Fourth here:\(self.userNum)")
            })
           
            .onReceive(self.myRoomData.noFourthPlayer, perform: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
                if self.userNum == -1 && self.myRoomData.roomData.user3.userName == ""{
                    self.userNum = 2
                }
                print("noFourth here:\(self.userNum)")
                }
            })
            
            .onReceive(self.myRoomData.roomReady, perform: { _ in
                print("Get Ready, Goto Game View.")
                //turn Room status to gaming
                self.myRoomData.setRoomGameStatus(status: true)
                self.myRoomData.removeRoomListener()
                self.gotoGameView = true
            })
            .onReceive(self.myRoomData.changeHost, perform: { _ in
                if userNum == 1{
                    self.showHostLeft = true
                    self.userNum = 0
                }
            })
            .background(Image("bg2").blur(radius: 10).contrast(0.69))
            .navigationTitle(NSLocalizedString("等待房間: ", comment: "") + titleText)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action:{
                    if userNum == 0 && self.myRoomData.roomData.user1.userName != "" {
                        self.myRoomData.leaveRoom(userNum: 0)
                    } else if userNum == 0 && self.myRoomData.roomData.user1.userName == "" {
                        self.myRoomData.removeRoomListener()
                        self.myRoomData.delRoom()
                    } else {
                        self.myRoomData.leaveRoom(userNum: 1)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                HStack {
                    Image(systemName: "figure.walk")
                    Text("離開")
                }.font(.title3)
                .foregroundColor(midNightBlue)
            }, trailing:
                Button(action:{
                if self.userNum == 0{
                    if myRoomData.roomData.user1ready && myRoomData.roomData.user2ready && myRoomData.roomData.user3ready {
                        myRoomData.selectStartPlayer()
                        myRoomData.getReady(userNum: 0)
                    } else{
                        self.notReadyAlert = true
                    }
                }
                else if self.userNum == 1{
                    if self.myRoomData.roomData.user1ready{
                        self.myRoomData.cancelReady(userNum: 1)
                    } else {
                        self.myRoomData.getReady(userNum: 1)
                    }
                }
                
                else if self.userNum == 2{
                    if self.myRoomData.roomData.user2ready{
                        self.myRoomData.cancelReady(userNum: 2)
                    } else {
                        self.myRoomData.getReady(userNum: 2)
                    }
                }
                
                else{
                    if self.myRoomData.roomData.user3ready{
                        self.myRoomData.cancelReady(userNum: 3)
                    } else {
                        self.myRoomData.getReady(userNum: 3)
                    }
                }
                
            }){
                HStack {
                    if self.userNum == 0 {
                        Image(systemName: "gamecontroller")
                            .foregroundColor(.red)
                        Text("開始")
                            .foregroundColor(.red)
                    }else{
                        if self.userNum == 1 && self.myRoomData.roomData.user1ready == false {
                            Image(systemName: "gamecontroller")
                            Text("準備")
                        } else if self.userNum == 1 && self.myRoomData.roomData.user1ready {
                            Image(systemName: "gamecontroller")
                            Text("取消準備")
                        }
                        if self.userNum == 2 && self.myRoomData.roomData.user2ready == false {
                            Image(systemName: "gamecontroller")
                            Text("準備")
                        } else if self.userNum == 2 && self.myRoomData.roomData.user2ready {
                            Image(systemName: "gamecontroller")
                            Text("取消準備")
                        }
                        if self.userNum == 3 && self.myRoomData.roomData.user3ready == false {
                            Image(systemName: "gamecontroller")
                            Text("準備")
                        } else if self.userNum == 3 && self.myRoomData.roomData.user3ready {
                            Image(systemName: "gamecontroller")
                            Text("取消準備")
                        }
                    }
                }.font(.title3)
                .foregroundColor(midNightBlue)
            
            }.alert(isPresented: $notReadyAlert) { () -> Alert in
                return Alert(title: Text("尚未準備完成"), message: Text("有玩家還沒準備完成喔！"),  dismissButton: .default(Text("好")))
            })
        }.alert(isPresented: $showHostLeft) { () -> Alert in
            return Alert(title: Text("主持"), message: Text("由於主持人已離開，自動成為主持人"),  dismissButton: .default(Text("好")))
        }
    }
    
    func myCreatRoom(roomNum: String) {
        FireBase.shared.createRoom(ud: [currentUserData, secUserData, thirdUserData, fourthUserData], rP: roomPW, rid_str: roomNum) { result in
            switch result {
            case .success(let rNum):
                titleText = rNum
                print("創建房間成功，房號為: " + rNum)
                FireBase.shared.fetchRooms() { result in
                    switch result {
                    case .success(let rArray):
                        for r in rArray {
                            if r.id == rNum || r.id == mRN{
                                myRoomData.roomData = r
                                myRoomData.addRoomListener()
                                break
                            }
                        }
                    
                    case .failure(_):
                        print("fail")
                    }
                }
            case .failure(_):
                print("創建房間失敗")
            }
        }
    }
}

struct WaitingGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        WaitingGameView(currentUserData: UserData(id: "123", userID: "1234", userName: "勇者002", userPhotoURL:
        "https://firebasestorage.googleapis.com:443/v0/b/final-00857125.appspot.com/o/414626AC-C27C-4EC6-A7A9-1DEDD522AE8F.png?alt=media&token=f4236291-2218-439e-ad32-e7373864df51", userGender: "女", userBD: "2021 May 25", userFirstLogin: "2021 May 25 13:44", userCountry: "台灣"), roomPW: "556879", mRN: "1320")
        }
.previewInterfaceOrientation(.portrait)
    }
}
