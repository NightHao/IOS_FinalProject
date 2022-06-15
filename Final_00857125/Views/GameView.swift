//
//  GameView.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import SwiftUI
import Kingfisher
import URLImage
import GoogleMobileAds
import UIKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var gotoGameView : Bool
    @Binding var map:Bool
    @State var myRoomData: MyRoom
    @StateObject var myGameData = MyGame()
    @State private var firstButton = true
    @State var userNum: Int
    @State var startPlayer: Int
    @State private var playerPieceNum = 0
    @State private var lastPiece = (-1, -1)
    @State private var showGameOverAlert = false
    @State private var showsurrenderAlert = false
    @State private var showWinnerAlert = false
    @State private var showSkipAlert = false
    @State private var showGiveUpAlert = false
    @State private var skippedMsg = NSLocalizedString("遊戲進行中...", comment: "")
    @State private var pieceDegrees = 0.0
    @State private var myContrast = 1.0
    @State private var dollBGColor = [Color.clear, Color.clear, Color.clear, Color.clear]
    @State private var dollOLColor = [Color.clear, Color.clear, Color.clear, Color.clear]
    @State private var gameOverAlert = Alert(title: Text("null"))
    @State private var start_up :Bool = false
    @State private var can_change:Bool = false
    @State private var finished_alert: Bool = false
    @State private var take_risk_alert: Bool = false
    @State private var jail_alert: Bool = false
    @State private var leave_jail_alert: Bool = false
    @State private var risk_getmoney: Bool = false
    @State private var risk_submoney: Bool = false
    @State private var jail_round = 0
    let myRewardAD = RewardedAdController()
    
    let buy_controller = UIAlertController(title: "是否購買", message: "", preferredStyle: .alert)
    
    func initial(){
        let okAction = UIAlertAction(title: "買", style: .default){ _ in
        }
        let cancelAction = UIAlertAction(title: "不買", style: .cancel, handler: nil)
        buy_controller.addAction(okAction)
        buy_controller.addAction(cancelAction)
    }
    
    var body: some View {
        NavigationView {
        ZStack {
            VStack {
                HStack{
                    VStack {
                        if myGameData.myGameData.roomData.user0.userPhotoURL != ""{
                            KFImage(URL(string: myGameData.myGameData.roomData.user0.userPhotoURL)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 80)
                        }
                        Text(myRoomData.roomData.user0.userName)
                            .font(.title3)
                            .foregroundColor(midNightBlue)
                            .padding(.top)
                            .frame(height: 20)
                        Text("\(myGameData.myGameData.player0_money)")
                            .foregroundColor(midNightBlue)
                    }
                    .background(
                        slimeGreen
                            .frame(width: 100, height: 135)
                            .cornerRadius(20)
                            .scaledToFill()
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5))
                            )
                    .padding()
                    Spacer()
                    VStack {
                        if myGameData.myGameData.nowPlayer == 0 {
                            Text("現在輪到")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                                .bold()
                                .padding(.bottom)
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        } else if myGameData.myGameData.nowPlayer == 1{
                            Text("現在輪到")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                                .bold()
                                .padding(.bottom)
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                        
                    }.foregroundColor(midNightBlue)
                    Spacer()
                    VStack {
                        if myGameData.myGameData.roomData.user1.userPhotoURL != "" {
                            KFImage(URL(string: myRoomData.roomData.user1.userPhotoURL)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 80)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        }
                        Text(myRoomData.roomData.user1.userName)
                            .font(.title3)
                            .foregroundColor(midNightBlue)
                            .padding(.top)
                            .frame(height: 20)
                        Text("\(myGameData.myGameData.player1_money)")
                            .foregroundColor(midNightBlue)
                        
                    }
                    .background(
                        pikaPink
                            .frame(width: 100, height: 135)
                            .cornerRadius(20)
                            .scaledToFill()
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5))
                            )
                    .padding()
                }.padding()
            Spacer()
                Group{
                    ZStack{
                        VStack(alignment: .center, spacing: 0.0) {
                            ForEach(0..<6) { i in
                                HStack(spacing: 0.0) {
                                    ForEach(0..<6) { j in
                                        Rectangle()
                                            .frame(width: 55, height: 55)
                                            .foregroundColor(GridColor(i: i, j: j, color: myGameData.myGameData.monopoly_color[String(j)]![i]))
                                    }
                                }
                            }
                        }
                        Group{
                            if map == false{
                                if (myGameData.myGameData.monopoly_color[String(1)]![0] != 0){
                                    Image("build1")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -80,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(2)]![0] != 0{
                                    Image("build2")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -25,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(3)]![0] != 0{
                                    Image("build3")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 30,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(4)]![0] != 0{
                                    Image("build4")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 85,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![1] != 0{
                                    Image("build5")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:-82)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![2] != 0{
                                    Image("build6")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:-27)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![3] != 0{
                                    Image("build7")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:28)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![4] != 0{
                                    Image("build8")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:83)
                                }
                                if myGameData.myGameData.monopoly_color[String(4)]![5] != 0{
                                    Image("build9")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 85,y:120)
                                }
                                if myGameData.myGameData.monopoly_color[String(3)]![5] != 0{
                                    Image("build10")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 30,y:120)
                                }
                            }
                            else{
                                if (myGameData.myGameData.monopoly_color[String(1)]![0] != 0){
                                    Image("build17")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -80,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(2)]![0] != 0{
                                    Image("build18")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -25,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(3)]![0] != 0{
                                    Image("build19")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 30,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(4)]![0] != 0{
                                    Image("build20")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 85,y:-155)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![1] != 0{
                                    Image("build21")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:-82)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![2] != 0{
                                    Image("build22")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:-27)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![3] != 0{
                                    Image("build23")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:28)
                                }
                                if myGameData.myGameData.monopoly_color[String(5)]![4] != 0{
                                    Image("build24")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: 140,y:83)
                                }
                                if myGameData.myGameData.monopoly_color[String(4)]![5] != 0{
                                    Image("build25")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 85,y:120)
                                }
                                if myGameData.myGameData.monopoly_color[String(3)]![5] != 0{
                                    Image("build26")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: 30,y:120)
                                }

                            }
                        }
                        Group{
                            if map == false{
                                if myGameData.myGameData.monopoly_color[String(2)]![5] != 0{
                                    Image("build11")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -25,y:120)
                                }
                                if myGameData.myGameData.monopoly_color[String(1)]![5] != 0{
                                    Image("build12")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -80,y:120)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![4] != 0{
                                    Image("build13")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:82)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![3] != 0{
                                    Image("build14")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:27)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![2] != 0{
                                    Image("build15")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:-28)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![1] != 0{
                                    Image("build16")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:-83)
                                }
                            }
                            else{
                                if myGameData.myGameData.monopoly_color[String(2)]![5] != 0{
                                    Image("build27")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -25,y:120)
                                }
                                if myGameData.myGameData.monopoly_color[String(1)]![5] != 0{
                                    Image("build28")
                                        .resizable()
                                        .frame(width: 30, height: 55)
                                        .offset(x: -80,y:120)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![4] != 0{
                                    Image("build29")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:82)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![3] != 0{
                                    Image("build30")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:27)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![2] != 0{
                                    Image("build31")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:-28)
                                }
                                if myGameData.myGameData.monopoly_color[String(0)]![1] != 0{
                                    Image("build32")
                                        .resizable()
                                        .frame(width: 30, height: 50)
                                        .offset(x: -135,y:-83)
                                }
                            }
                            Image("jail")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .offset(x: 137,y:137)
                            Image("take_chance_1")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .offset(x: -137,y:137)
                            Image("take_chance_2")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .offset(x: 137,y:-137)
                        }
                        Group{
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(slimeGreen)
                                .shadow(color: .black, radius: 2)
                                .offset(x:CGFloat(myGameData.myGameData.player0_offset[0]+myGameData.myGameData.player0_offset[2]*55), y:CGFloat(myGameData.myGameData.player0_offset[1]+myGameData.myGameData.player0_offset[3]*55))
                                .animation(.default)
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(pikaPink)
                                .shadow(color: .black, radius: 2)
                                .offset(x:CGFloat(myGameData.myGameData.player1_offset[0]+myGameData.myGameData.player1_offset[2]*55), y:CGFloat(myGameData.myGameData.player1_offset[1]+myGameData.myGameData.player1_offset[3]*55))
                                .animation(.default)
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                                .shadow(color: .black, radius: 2)
                                .offset(x:CGFloat(myGameData.myGameData.player2_offset[0]+myGameData.myGameData.player2_offset[2]*55), y:CGFloat(myGameData.myGameData.player2_offset[1]+myGameData.myGameData.player2_offset[3]*55))
                                .animation(.default)
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.purple)
                                .shadow(color: .black, radius: 2)
                                .offset(x:CGFloat(myGameData.myGameData.player3_offset[0]+myGameData.myGameData.player3_offset[2]*55), y:CGFloat(myGameData.myGameData.player3_offset[1]+myGameData.myGameData.player3_offset[3]*55))
                                .animation(.default)
                        }
                        ZStack{
                        VStack{
                            HStack{
                                Image("dice\(myGameData.myGameData.dice_1)")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Image("dice\(myGameData.myGameData.dice_2)")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                            }
                            .alert("是否購買",isPresented: $start_up, actions:{
                                Button("買"){ //可能要加上金錢是否購買判定
                                    dingPlayer.playFromStart()
                                    if userNum == 0 && myGameData.myGameData.player0_money >= 1000{
                                        myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player0_offset[2])]![myGameData.myGameData.player0_offset[3]] = 1
                                        myGameData.myGameData.player0_money -= 1000
                                    }
                                    else if userNum == 1 && myGameData.myGameData.player1_money >= 1000{
                                        myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player1_offset[2])]![myGameData.myGameData.player1_offset[3]] = 2
                                        myGameData.myGameData.player1_money -= 1000
                                    }
                                    else if userNum == 2 && myGameData.myGameData.player2_money >= 1000{
                                        myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player2_offset[2])]![myGameData.myGameData.player2_offset[3]] = 3
                                        myGameData.myGameData.player2_money -= 1000
                                    }
                                    else if userNum == 3 && myGameData.myGameData.player3_money >= 1000{
                                        myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player3_offset[2])]![myGameData.myGameData.player3_offset[3]] = 4
                                        myGameData.myGameData.player3_money -= 1000
                                    }
                                    start_up = false
                                    myGameData.update_db()
                                    print("before change:\(userNum)")
                                    if myGameData.myGameData.dice_1 != myGameData.myGameData.dice_2{
                                        myGameData.turnPlayer(nowPlayer: userNum)
                                        if myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                            print("放棄\(myGameData.myGameData.nowPlayer)")
                                            myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                                        }
                                        else{
                                            print("未放棄\(myGameData.myGameData.nowPlayer)")
                                        }
                                    }
                                    print("after change:\(userNum)")
                                }
                                Button("不了"){
                                    dingPlayer.playFromStart()
                                    start_up = false
                                    myGameData.update_db()
                                    print("before change:\(userNum)")
                                    if myGameData.myGameData.dice_1 != myGameData.myGameData.dice_2{
                                        myGameData.turnPlayer(nowPlayer: userNum)
                                        if myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                            print("放棄\(myGameData.myGameData.nowPlayer)")
                                            myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                                        }
                                        else{
                                            print("未放棄\(myGameData.myGameData.nowPlayer)")
                                        }
                                    }
                                    print("after change:\(userNum)")
                                }
                            })
                            
                            /*.alert("獲得過路費", isPresented: $myGameData.myGameData.getmoney[userNum], actions:{
                                Button("OK"){
                                    myGameData.myGameData.getmoney[userNum] = false
                                    myGameData.update_pay()
                                }
                            })
                            .alert("付出過路費", isPresented: $myGameData.myGameData.submoney[userNum], actions:{
                                Button("OK"){
                                    myGameData.myGameData.submoney[userNum] = false
                                    myGameData.update_pay()
                                }
                            })*/
                            .alert("你贏了", isPresented: $showWinnerAlert, actions:{
                                Button("返回"){
                                    dingPlayer.playFromStart()
                                    turnBackToRoomView()
                                }
                            })
                            .alert("你投降了", isPresented: $showsurrenderAlert, actions:{
                                Button("觀戰"){
                                    dingPlayer.playFromStart()
                                    showsurrenderAlert = false
                                    
                                }
                            })
                            .alert("你輸了", isPresented: $myGameData.myGameData.out_alert[userNum], actions:{
                                Button("返回"){
                                    dingPlayer.playFromStart()
                                    myGameData.myGameData.out_alert[userNum] = false
                                    myGameData.update_out_alert()
                                    turnBackToRoomView()
                                }
                            })
                            .alert("你被關進監獄了", isPresented: $jail_alert, actions:{
                                Button("QQ"){
                                    dingPlayer.playFromStart()
                                    myGameData.myGameData.player_jail[userNum] = true
                                    myGameData.update_db()
                                    myGameData.turnPlayer(nowPlayer: userNum)
                                    jail_alert = false
                                }
                            })
                            .alert("你出獄了", isPresented: $leave_jail_alert, actions:{
                                Button("YES"){
                                    dingPlayer.playFromStart()
                                    myGameData.myGameData.player_jail[userNum] = false
                                    myGameData.update_db()
                                    leave_jail_alert = false
                                }
                            })
                            /*.alert("投資成功 獲得兩千塊", isPresented: $risk_getmoney, actions:{
                                Button("OK"){
                                    risk_getmoney = false
                                }
                            })*/
                            /*.alert("投資失敗 失去兩千塊", isPresented: $risk_submoney_alert, actions:{
                                Button("OK"){
                                    risk_submoney_alert = false
                                }
                            })*/
                            .alert("是否冒險投資",isPresented: $take_risk_alert, actions:{
                                Button("買"){ //可能要加上金錢是否購買判定
                                    dingPlayer.playFromStart()
                                    var win_or_lose = Int.random(in: 1...2)
                                    if win_or_lose == 1{
                                        if userNum == 0{
                                            myGameData.myGameData.player0_money += 2000
                                            risk_getmoney = true
                                        }
                                        else if userNum == 1{
                                            myGameData.myGameData.player1_money += 2000
                                            risk_getmoney = true
                                        }
                                        else if userNum == 2{
                                            myGameData.myGameData.player2_money += 2000
                                            risk_getmoney = true
                                        }
                                        else{
                                            myGameData.myGameData.player3_money += 2000
                                            risk_getmoney = true
                                        }
                                    }
                                    else{
                                        if userNum == 0{
                                            myGameData.myGameData.player0_money -= 2000
                                            risk_submoney = true
                                        }
                                        else if userNum == 1{
                                            myGameData.myGameData.player1_money -= 2000
                                            risk_submoney = true
                                        }
                                        else if userNum == 2{
                                            myGameData.myGameData.player2_money -= 2000
                                            risk_submoney = true
                                        }
                                        else{
                                            myGameData.myGameData.player3_money -= 2000
                                            risk_submoney = true
                                        }
                                    }
                                    take_risk_alert = false
                                    myGameData.update_db()
                                    lose_judge()
                                }
                                Button("不了"){
                                    dingPlayer.playFromStart()
                                    take_risk_alert = false
                                    myGameData.update_db()
                                }
                            })

                            if myGameData.myGameData.nowPlayer == userNum && myGameData.myGameData.player_jail[userNum] == false{
                                VStack{
                                    Button("點擊"){
                                        dingPlayer.playFromStart()
                                        lose_judge()
                                        myGameData.myGameData.dice_1 = Int.random(in: 1...6)
                                        myGameData.myGameData.dice_2 = Int.random(in: 1...6)
                                        myGameData.update_dices()
                                        count_step(step1: myGameData.myGameData.dice_1, step2:myGameData.myGameData.dice_2, player_num: userNum)
                                        if myGameData.myGameData.userGiveUp[userNum] == true{
                                            print("已經放棄")
                                        }
                                        
                                    }
                                    Button("賣地"){
                                        dingPlayer.playFromStart()
                                        sell_territory()
                                    }
                                }
                                
                            }
                            if myGameData.myGameData.nowPlayer == userNum && myGameData.myGameData.player_jail[userNum] == true{
                                Button("點擊"){
                                    dingPlayer.playFromStart()
                                    jail_round += 1
                                    if jail_round == 2{
                                        leave_jail_alert = true
                                        jail_round = 0
                                    }
                                    else{
                                        myGameData.turnPlayer(nowPlayer: userNum)
                                    }
                                }
                            }
                        }
                            if myGameData.myGameData.getmoney[userNum] == true{
                                VStack{
                                    Image("money")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Text("獲得過路費")
                                }
                                .shadow(color: Color.green, radius: 10)
                                .transition(.scale)
                                .onAppear(perform: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        myGameData.myGameData.getmoney[userNum] = false
                                        myGameData.update_pay()
                                    })
                                })
                            }
                            if myGameData.myGameData.submoney[userNum] == true{
                                VStack{
                                    Image("money")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Text("支付過路費")
                                }
                                .shadow(color: Color.red, radius: 10)
                                .transition(.scale)
                                .onAppear(perform: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        myGameData.myGameData.submoney[userNum] = false
                                        myGameData.update_pay()
                                    })
                                })
                            }
                            if risk_getmoney == true{
                                VStack{
                                    Image("money")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Text("獲得兩千塊")
                                }
                                .shadow(color: Color.green, radius: 10)
                                .transition(.scale)
                                .onAppear(perform: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        risk_getmoney = false
                                    })
                                })
                            }
                            if risk_submoney == true{
                                VStack{
                                    Image("money")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Text("失去兩千塊")
                                }
                                .shadow(color: Color.red, radius: 10)
                                .transition(.scale)
                                .onAppear(perform: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        risk_submoney = false
                                    })
                                })
                            }
                        }
                        /*.onReceive(myGameData.giveupP0, perform: { _ in
                            print("user0投降")
                            //self.whoWIN(isGiveUp: true, giveupUser: 0)
                            //self.showGameOverAlert = true
                        })
                        .onReceive(myGameData.giveupP1, perform: { _ in
                            print("user1投降")
                            //self.whoWIN(isGiveUp: true, giveupUser: 1)
                            //self.showGameOverAlert = true
                        })
                        .onReceive(myGameData.giveupP2, perform: { _ in
                            print("user2投降")
                            //self.whoWIN(isGiveUp: true, giveupUser: 1)
                            //self.showGameOverAlert = true
                        })
                        .onReceive(myGameData.giveupP3, perform: { _ in
                            print("user3投降")
                            //self.whoWIN(isGiveUp: true, giveupUser: 1)
                            //self.showGameOverAlert = true
                        })*/
                        .onReceive(myGameData.gameOver, perform: { _ in
                            print(myGameData.myGameData.checkerboard)
                            self.whoWIN()
                            self.showGameOverAlert = true
                        })
                    }
                }
                HStack{
                    VStack {
                        if myGameData.myGameData.roomData.user2.userPhotoURL != ""{
                            KFImage(URL(string: myGameData.myGameData.roomData.user2.userPhotoURL)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 80)
                        }
                        Text(myRoomData.roomData.user2.userName)
                            .font(.title3)
                            .foregroundColor(midNightBlue)
                            .padding(.top)
                            .frame(height: 20)
                        Text("\(myGameData.myGameData.player2_money)")
                            .foregroundColor(midNightBlue)
                    }
                    .background(
                        Color.blue
                            .frame(width: 100, height: 135)
                            .cornerRadius(20)
                            .scaledToFill()
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5))
                            )
                    .padding()
                    Spacer()
                    VStack {
                        if myGameData.myGameData.nowPlayer == 2 {
                            Text("現在輪到")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                                .bold()
                                .padding(.bottom)
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        } else if myGameData.myGameData.nowPlayer == 3{
                            Text("現在輪到")
                                .font(.system(size: 13))
                                .foregroundColor(.black)
                                .bold()
                                .padding(.bottom)
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                        
                    }.foregroundColor(midNightBlue)
                    Spacer()
                    VStack {
                        if myGameData.myGameData.roomData.user3.userPhotoURL != "" {
                            KFImage(URL(string: myRoomData.roomData.user3.userPhotoURL)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 80)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        }
                        Text(myRoomData.roomData.user3.userName)
                            .font(.title3)
                            .foregroundColor(midNightBlue)
                            .padding(.top)
                            .frame(height: 20)
                        Text("\(myGameData.myGameData.player3_money)")
                            .foregroundColor(midNightBlue)
                    }
                    .background(
                        Color.purple
                            .frame(width: 100, height: 135)
                            .cornerRadius(20)
                            .scaledToFill()
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5))
                            )
                    .padding()
                }.padding()
            }.alert(isPresented: $showGameOverAlert) { () -> Alert in
                return gameOverAlert
            }
        }
        .background(Image("bg2").blur(radius: 10).contrast(0.8))
        .navigationBarItems(leading:
            Text(NSLocalizedString("房號: ", comment: "") + myRoomData.roomData.id!).font(.title).bold().foregroundColor(.black), trailing:
                Button(action:{self.showGiveUpAlert = true}){
                HStack {
                    Image(systemName: "figure.walk")
                    Text("投降")
                }.font(.title3)
                .foregroundColor(.red)
                }.alert(isPresented: $showGiveUpAlert){ () -> Alert in
                    return Alert(title: Text("投降"), message: Text("您確定真的要投降嗎"),  primaryButton: .default(Text("確定"), action: {
                        myGameData.myGameData.userGiveUp[userNum] = true
                        myGameData.setGiveUp()
                        showGiveUpAlert = false
                        showsurrenderAlert = true
                        }),secondaryButton: .default(Text("取消")))
                })
        }.onAppear {
            myRewardAD.loadAD()
            /*if userNum == startPlayer {
                playerPieceNum = 1
                if userNum == 0 {
                    dollBGColor = [slimeGreen, pikaPink]
                    dollOLColor = [dpSlimeGreen, dpPikaPink]
                } else {
                    dollBGColor = [pikaPink, slimeGreen]
                    dollOLColor = [dpPikaPink, dpSlimeGreen]
                }
            } else {
                playerPieceNum = 2
                if userNum == 0 {
                    dollBGColor = [pikaPink, slimeGreen]
                    dollOLColor = [dpPikaPink, dpSlimeGreen]
                } else {
                    dollBGColor = [slimeGreen, pikaPink]
                    dollOLColor = [dpSlimeGreen, dpPikaPink]
                }
            }*/
            print("My Piece Num: " + String(playerPieceNum))
            myGameData.myGameData.roomData = myRoomData.roomData
            FireBase.shared.createGame(rd: myRoomData.roomData, startPlayer: startPlayer) { result in
                switch result {
                    case .success(let msg):
                        myGameData.addGameListener()
                        print("遊戲開始：" + msg)
                    case .failure(_):
                        print("發生錯誤，遊戲開始失敗")
                }
            }
        }
    }
    
    struct message: View {
        @State var showingMessage: Bool
        let text: String
        @State private var scale: CGFloat = 1
        var body: some View {
            Text(text)
                .font(.largeTitle)
                .scaleEffect(scale)
                .animation(.easeIn)
                .onAppear(perform: {
                    withAnimation(.easeInOut(duration: 1.5)) { scale = 1.5 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.showingMessage = false
                    })
                })
        }
    }
    
    func sell_territory(){
        for i in 0..<6{
            for j in 0..<6{
                if myGameData.myGameData.monopoly_color[String(j)]![i] == userNum + 1{
                    myGameData.myGameData.monopoly_color[String(j)]![i] = 0
                    if userNum == 0{
                        myGameData.myGameData.player0_money += 1000
                    }
                    else if userNum == 1{
                        myGameData.myGameData.player1_money += 1000
                    }
                    else if userNum == 2{
                        myGameData.myGameData.player2_money += 1000
                    }
                    else{
                        myGameData.myGameData.player3_money += 1000
                    }
                    myGameData.update_db()
                    myGameData.update_pay()
                    break
                }
            }
        }
    }
    
    func lose_judge(){
        if userNum == 0 && myGameData.myGameData.player0_money < 0{
            myGameData.myGameData.userGiveUp[userNum] = true
        }
        if userNum == 1 && myGameData.myGameData.player1_money < 0{
            myGameData.myGameData.userGiveUp[userNum] = true
        }
        if userNum == 2 && myGameData.myGameData.player2_money < 0{
            myGameData.myGameData.userGiveUp[userNum] = true
        }
        if userNum == 3 && myGameData.myGameData.player3_money < 0{
            myGameData.myGameData.userGiveUp[userNum] = true
        }
        myGameData.setGiveUp()
        if userNum == 0 && myGameData.myGameData.userGiveUp[1] == true && myGameData.myGameData.userGiveUp[2] == true && myGameData.myGameData.userGiveUp[3] == true{
            myGameData.countWinandLose(user: userNum)
            myGameData.myGameData.out_alert[1] = true
            myGameData.myGameData.out_alert[2] = true
            myGameData.myGameData.out_alert[3] = true
            myGameData.update_out_alert()
            showWinnerAlert = true
        }
        if userNum == 1 && myGameData.myGameData.userGiveUp[0] == true && myGameData.myGameData.userGiveUp[2] == true && myGameData.myGameData.userGiveUp[3] == true{
            myGameData.countWinandLose(user: userNum)
            myGameData.myGameData.out_alert[0] = true
            myGameData.myGameData.out_alert[2] = true
            myGameData.myGameData.out_alert[3] = true
            myGameData.update_out_alert()
            showWinnerAlert = true
        }
        if userNum == 2 && myGameData.myGameData.userGiveUp[0] == true && myGameData.myGameData.userGiveUp[1] == true && myGameData.myGameData.userGiveUp[3] == true{
            myGameData.countWinandLose(user: userNum)
            myGameData.myGameData.out_alert[0] = true
            myGameData.myGameData.out_alert[1] = true
            myGameData.myGameData.out_alert[3] = true
            myGameData.update_out_alert()
            showWinnerAlert = true
        }
        if userNum == 3 && myGameData.myGameData.userGiveUp[0] == true && myGameData.myGameData.userGiveUp[1] == true && myGameData.myGameData.userGiveUp[2] == true{
            myGameData.countWinandLose(user: userNum)
            myGameData.myGameData.out_alert[0] = true
            myGameData.myGameData.out_alert[1] = true
            myGameData.myGameData.out_alert[2] = true
            myGameData.update_out_alert()
            showWinnerAlert = true
        }
    }
    
    func whoWIN(isGiveUp: Bool = false, giveupUser: Int = -1) -> Void {
        var player1Count = 0
        var player2Count = 0
        let user0N = self.myRoomData.roomData.user0.userName
        let user1N = self.myRoomData.roomData.user1.userName
        for i in 0..<8 {
            for j in 0..<8 {
                if myGameData.myGameData.checkerboard[String(i)]![j] == 1 {
                    player1Count += 1
                } else if myGameData.myGameData.checkerboard[String(i)]![j] == 2 {
                    player2Count += 1
                }
            }
        }
        if isGiveUp && (giveupUser == 0 || giveupUser == 1) {
            if userNum == 0 {
                myGameData.countWinandLose(user: 1 - giveupUser)
            }
            if userNum == giveupUser {
                gameOverAlert = Alert(title: Text("輸了！"), message: Text("你投降了!"), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()}))
            } else {
                gameOverAlert = Alert(title: Text("獲勝！"), message: Text("對手投降了!"), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()}))
            }
        } else {
            if player1Count > player2Count {
                if playerPieceNum == 1 {
                    if userNum == 0 {
                        myGameData.countWinandLose(user: 0)
                        gameOverAlert = Alert(title: Text("獲勝！"), message: Text(NSLocalizedString("你(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count) + NSLocalizedString("\n對手(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    } else {
                        gameOverAlert = Alert(title: Text("獲勝！"), message: Text(NSLocalizedString("你(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count) + NSLocalizedString("\n對手(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    }
                } else {
                    if userNum == 0 {
                        myGameData.countWinandLose(user: 1)
                        gameOverAlert = Alert(title: Text("輸了！"), message: Text(NSLocalizedString("你(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count) + NSLocalizedString("\n對手(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    } else {
                        gameOverAlert = Alert(title: Text("輸了！"), message: Text(NSLocalizedString("你(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count) + NSLocalizedString("\n對手(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    }
                }
            } else if player2Count > player1Count {
                if playerPieceNum == 1 {
                    if userNum == 0 {
                        myGameData.countWinandLose(user: 1)
                        gameOverAlert = Alert(title: Text("輸了！"), message: Text(NSLocalizedString("你(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count) + NSLocalizedString("\n對手(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    } else {
                        gameOverAlert = Alert(title: Text("輸了！"), message: Text(NSLocalizedString("你(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count) + NSLocalizedString("\n對手(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    }
                } else {
                    if userNum == 0 {
                        myGameData.countWinandLose(user: 0)
                        gameOverAlert = Alert(title: Text("獲勝！"), message: Text(NSLocalizedString("你(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count) + NSLocalizedString("\n對手(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    } else {
                        gameOverAlert = Alert(title: Text("獲勝！"), message: Text(NSLocalizedString("你(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count) + NSLocalizedString("\n對手(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                        }))
                    }
                }
            } else if player1Count == player2Count {
                if userNum == 0 {
                    gameOverAlert = Alert(title: Text("平手！"), message: Text(NSLocalizedString("你(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count) + NSLocalizedString("\n對手(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                    }))
                } else {
                    gameOverAlert = Alert(title: Text("平手！"), message: Text(NSLocalizedString("你(", comment: "") + user1N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player1Count) + NSLocalizedString("\n對手(", comment: "") + user0N + NSLocalizedString(")的棋子數目: ", comment: "") + String(player2Count)), dismissButton: .default(Text("OK"), action: {turnBackToRoomView()
                    }))
                }
            }
        }
    }
    
    func turnBackToRoomView() -> Void {
        self.myGameData.removeGameListener()
        if self.userNum == 0 {
            self.myGameData.delGameRoom()
            self.myRoomData.setRoomGameStatus(status: false)
        }
        self.myRoomData.cancelReady(userNum: 0)
        self.myRoomData.cancelReady(userNum: 1)
        self.myRoomData.cancelReady(userNum: 2)
        self.myRoomData.cancelReady(userNum: 3)
        self.myRoomData.addRoomListener()
        self.gotoGameView = false
    }
    
    func GridColor(i:Int, j:Int, color:Int)->Color{
        if color == 0{
            if i != 0 && i != 5 && j != 0 && j != 5{
                return Color.clear
            }
            if (i == 0 && j == 0) || (i == 0 && j == 5) || (i == 5 && j == 0) || (i == 5 && j == 5){
                return Color.gray
            }
            if i % 2 == 0{
                if j % 2 == 0{
                    return Color.brown
                }
                else{
                    return Color.yellow
                }
            }
            else{
                if j % 2 == 0{
                    return Color.yellow
                }
                else{
                    return Color.brown
                }
            }
        }
        else{
            if color == 1{
                return slimeGreen
            }
            else if color == 2{
                return pikaPink
            }
            else if color == 3{
                return Color.blue
            }
            else{
                return Color.purple
            }
        }
    }
    
    func count_step(step1:Int, step2:Int, player_num:Int){
        var step = step1 + step2
        var count_times = 0
        var timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){ t in
            count_times += 1
            if player_num == 0{
                if myGameData.myGameData.player0_offset[3] == 0 && myGameData.myGameData.player0_offset[2] != 5{
                    myGameData.myGameData.player0_offset[2] += 1
                }
                else if myGameData.myGameData.player0_offset[2] == 5 && myGameData.myGameData.player0_offset[3] != 5{
                    myGameData.myGameData.player0_offset[3] += 1
                }
                else if myGameData.myGameData.player0_offset[3] == 5 && myGameData.myGameData.player0_offset[2] != 0{
                    myGameData.myGameData.player0_offset[2] -= 1
                }
                else if myGameData.myGameData.player0_offset[2] == 0 && myGameData.myGameData.player0_offset[3] != 0{
                    myGameData.myGameData.player0_offset[3] -= 1
                }
                myGameData.update_offset()
            }
            else if player_num == 1{
                if myGameData.myGameData.player1_offset[3] == 0 && myGameData.myGameData.player1_offset[2] != 5{
                    myGameData.myGameData.player1_offset[2] += 1
                }
                else if myGameData.myGameData.player1_offset[2] == 5 && myGameData.myGameData.player1_offset[3] != 5{
                    myGameData.myGameData.player1_offset[3] += 1
                }
                else if myGameData.myGameData.player1_offset[3] == 5 && myGameData.myGameData.player1_offset[2] != 0{
                    myGameData.myGameData.player1_offset[2] -= 1
                }
                else if myGameData.myGameData.player1_offset[2] == 0 && myGameData.myGameData.player1_offset[3] != 0{
                    myGameData.myGameData.player1_offset[3] -= 1
                }
                myGameData.update_offset()
            }
            else if player_num == 2{
                if myGameData.myGameData.player2_offset[3] == 0 && myGameData.myGameData.player2_offset[2] != 5{
                    myGameData.myGameData.player2_offset[2] += 1
                }
                else if myGameData.myGameData.player2_offset[2] == 5 && myGameData.myGameData.player2_offset[3] != 5{
                    myGameData.myGameData.player2_offset[3] += 1
                }
                else if myGameData.myGameData.player2_offset[3] == 5 && myGameData.myGameData.player2_offset[2] != 0{
                    myGameData.myGameData.player2_offset[2] -= 1
                }
                else if myGameData.myGameData.player2_offset[2] == 0 && myGameData.myGameData.player2_offset[3] != 0{
                    myGameData.myGameData.player2_offset[3] -= 1
                }
                myGameData.update_offset()
            }
            else{
                if myGameData.myGameData.player3_offset[3] == 0 && myGameData.myGameData.player3_offset[2] != 5{
                    myGameData.myGameData.player3_offset[2] += 1
                }
                else if myGameData.myGameData.player3_offset[2] == 5 && myGameData.myGameData.player3_offset[3] != 5{
                    myGameData.myGameData.player3_offset[3] += 1
                }
                else if myGameData.myGameData.player3_offset[3] == 5 && myGameData.myGameData.player3_offset[2] != 0{
                    myGameData.myGameData.player3_offset[2] -= 1
                }
                else if myGameData.myGameData.player3_offset[2] == 0 && myGameData.myGameData.player3_offset[3] != 0{
                    myGameData.myGameData.player3_offset[3] -= 1
                }
                myGameData.update_offset()
            }
            if count_times >= step{
                if player_num == 0{
                    if myGameData.myGameData.player0_offset[2] == 5 && myGameData.myGameData.player0_offset[3] == 5{
                        jail_alert = true
                    }
                    else if (myGameData.myGameData.player0_offset[2] == 0 && myGameData.myGameData.player0_offset[3] == 5) || (myGameData.myGameData.player0_offset[2] == 5 && myGameData.myGameData.player0_offset[3] == 0){
                        take_risk_alert = true
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                        }
                    }
                    else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player0_offset[2])]![myGameData.myGameData.player0_offset[3]] == 0 && (myGameData.myGameData.player0_offset[2] != 0 || myGameData.myGameData.player0_offset[3] != 0){
                        if showWinnerAlert == false{
                            start_up = true
                        }
                    }
                    else{
                        if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player0_offset[2])]![myGameData.myGameData.player0_offset[3]] == 2{
                            myGameData.myGameData.player1_money += 1000
                            myGameData.myGameData.player0_money -= 1000
                            myGameData.myGameData.submoney[0] = true
                            myGameData.myGameData.getmoney[1] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player0_offset[2])]![myGameData.myGameData.player0_offset[3]] == 3{
                            myGameData.myGameData.player2_money += 1000
                            myGameData.myGameData.player0_money -= 1000
                            myGameData.myGameData.submoney[0] = true
                            myGameData.myGameData.getmoney[2] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player0_offset[2])]![myGameData.myGameData.player0_offset[3]] == 4{
                            myGameData.myGameData.player3_money += 1000
                            myGameData.myGameData.player0_money -= 1000
                            myGameData.myGameData.submoney[0] = true
                            myGameData.myGameData.getmoney[3] = true
                        }
                        myGameData.update_db()
                        myGameData.update_pay()
                        lose_judge()
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                }
                else if player_num == 1{
                    if myGameData.myGameData.player1_offset[2] == 5 && myGameData.myGameData.player1_offset[3] == 5{
                        jail_alert = true
                    }
                    else if (myGameData.myGameData.player1_offset[2] == 0 && myGameData.myGameData.player1_offset[3] == 5) || (myGameData.myGameData.player1_offset[2] == 5 && myGameData.myGameData.player1_offset[3] == 0){
                        take_risk_alert = true
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                    else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player1_offset[2])]![myGameData.myGameData.player1_offset[3]] == 0 && (myGameData.myGameData.player1_offset[2] != 0 || myGameData.myGameData.player1_offset[3] != 0){
                        if showWinnerAlert == false{
                            start_up = true
                        }
                    }
                    else{
                        if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player1_offset[2])]![myGameData.myGameData.player1_offset[3]] == 1{
                            myGameData.myGameData.player1_money -= 1000
                            myGameData.myGameData.player0_money += 1000
                            myGameData.myGameData.submoney[1] = true
                            myGameData.myGameData.getmoney[0] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player1_offset[2])]![myGameData.myGameData.player1_offset[3]] == 3{
                            myGameData.myGameData.player1_money -= 1000
                            myGameData.myGameData.player2_money += 1000
                            myGameData.myGameData.submoney[1] = true
                            myGameData.myGameData.getmoney[2] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player1_offset[2])]![myGameData.myGameData.player1_offset[3]] == 4{
                            myGameData.myGameData.player1_money -= 1000
                            myGameData.myGameData.player3_money += 1000
                            myGameData.myGameData.submoney[1] = true
                            myGameData.myGameData.getmoney[3] = true
                        }
                        myGameData.update_db()
                        myGameData.update_pay()
                        lose_judge()
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                }
                else if player_num == 2{
                    if myGameData.myGameData.player2_offset[2] == 5 && myGameData.myGameData.player2_offset[3] == 5{
                        jail_alert = true
                    }
                    else if (myGameData.myGameData.player2_offset[2] == 0 && myGameData.myGameData.player2_offset[3] == 5) || (myGameData.myGameData.player2_offset[2] == 5 && myGameData.myGameData.player2_offset[3] == 0){
                        take_risk_alert = true
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                    else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player2_offset[2])]![myGameData.myGameData.player2_offset[3]] == 0 && (myGameData.myGameData.player2_offset[2] != 0 || myGameData.myGameData.player2_offset[3] != 0){
                        if showWinnerAlert == false{
                            start_up = true
                        }
                    }
                    else{
                        if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player2_offset[2])]![myGameData.myGameData.player2_offset[3]] == 1{
                            myGameData.myGameData.player0_money += 1000
                            myGameData.myGameData.player2_money -= 1000
                            myGameData.myGameData.submoney[2] = true
                            myGameData.myGameData.getmoney[0] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player2_offset[2])]![myGameData.myGameData.player2_offset[3]] == 2{
                            myGameData.myGameData.player1_money += 1000
                            myGameData.myGameData.player2_money -= 1000
                            myGameData.myGameData.submoney[2] = true
                            myGameData.myGameData.getmoney[1] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player2_offset[2])]![myGameData.myGameData.player2_offset[3]] == 4{
                            myGameData.myGameData.player3_money += 1000
                            myGameData.myGameData.player2_money -= 1000
                            myGameData.myGameData.submoney[2] = true
                            myGameData.myGameData.getmoney[3] = true
                        }
                        myGameData.update_db()
                        myGameData.update_pay()
                        lose_judge()
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                }
                else{
                    if myGameData.myGameData.player3_offset[2] == 5 && myGameData.myGameData.player3_offset[3] == 5{
                        jail_alert = true
                    }
                    else if (myGameData.myGameData.player3_offset[2] == 0 && myGameData.myGameData.player3_offset[3] == 5) || (myGameData.myGameData.player3_offset[2] == 5 && myGameData.myGameData.player3_offset[3] == 0){
                        take_risk_alert = true
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                    else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player3_offset[2])]![myGameData.myGameData.player3_offset[3]] == 0 && (myGameData.myGameData.player3_offset[2] != 0 || myGameData.myGameData.player3_offset[3] != 0){
                        if showWinnerAlert == false{
                            start_up = true
                        }
                    }
                    else{
                        if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player3_offset[2])]![myGameData.myGameData.player3_offset[3]] == 1{
                            myGameData.myGameData.player0_money += 1000
                            myGameData.myGameData.player3_money -= 1000
                            myGameData.myGameData.submoney[3] = true
                            myGameData.myGameData.getmoney[0] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player3_offset[2])]![myGameData.myGameData.player3_offset[3]] == 2{
                            myGameData.myGameData.player1_money += 1000
                            myGameData.myGameData.player3_money -= 1000
                            myGameData.myGameData.submoney[3] = true
                            myGameData.myGameData.getmoney[1] = true
                        }
                        else if myGameData.myGameData.monopoly_color[String(myGameData.myGameData.player3_offset[2])]![myGameData.myGameData.player3_offset[3]] == 3{
                            myGameData.myGameData.player2_money += 1000
                            myGameData.myGameData.player3_money -= 1000
                            myGameData.myGameData.submoney[3] = true
                            myGameData.myGameData.getmoney[2] = true
                        }
                        myGameData.update_db()
                        myGameData.update_pay()
                        lose_judge()
                        if step1 != step2{
                            myGameData.turnPlayer(nowPlayer: userNum)
                            while myGameData.myGameData.userGiveUp[myGameData.myGameData.nowPlayer] == true{
                                print("放棄\(myGameData.myGameData.nowPlayer)")
                                myGameData.turnPlayer(nowPlayer: myGameData.myGameData.nowPlayer)
                            }
                            
                        }
                    }
                }
                t.invalidate()
            }
        }
    
    }
    
}
/*struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gotoGameView: .constant(true), myRoomData: MyRoom(), userNum: 1, startPlayer: 0)
    }
}*/
