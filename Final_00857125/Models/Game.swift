//
//  Game.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import SwiftUI
import Foundation
import AVFoundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class MyGame: ObservableObject {
    @Published var myGameData: GameData
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    let changePlayer = NotificationCenter.default.publisher(for: Notification.Name("changePlayer"))
    let skipP0 = NotificationCenter.default.publisher(for: Notification.Name("skipP0"))
    let skipP1 = NotificationCenter.default.publisher(for: Notification.Name("skipP1"))
    let gameNormal = NotificationCenter.default.publisher(for: Notification.Name("gn"))
    let giveupP0 = NotificationCenter.default.publisher(for: Notification.Name("giveupP0"))
    let giveupP1 = NotificationCenter.default.publisher(for: Notification.Name("giveupP1"))
    let giveupP2 = NotificationCenter.default.publisher(for: Notification.Name("giveupP2"))
    let giveupP3 = NotificationCenter.default.publisher(for: Notification.Name("giveupP3"))
    let gameOver = NotificationCenter.default.publisher(for: Notification.Name("gameOver"))
    init() {
        self.myGameData = GameData(roomData: RoomData(id: "", user0: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user0ready: false, user1: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user1ready: false, user2: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user2ready: false, user3: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user3ready: false, roundTime: 0, roomPassWord: "", startPlayer: 0, roomGameStatus: false), nowPlayer: 0)
    }
    
    func copyGame(newGame: GameData) -> Void {
        self.myGameData = newGame
    }
    
    
    func addGameListener() -> Void {
        self.listener = self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").addSnapshotListener{
            snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let game = try? snapshot.data(as: GameData.self) else { return }
//            if(self.myGameData.nowPlayer != game.nowPlayer) {
//                NotificationCenter.default.post(name: Notification.Name("changePlayer"), object: nil)
//            }
            self.copyGame(newGame: game)
            print("Game data update!")
            
            //SKIPPED
            if(self.myGameData.user0Skipped) {
                NotificationCenter.default.post(name: Notification.Name("skipP0"), object: nil)
            }
            if(self.myGameData.user1Skipped) {
                NotificationCenter.default.post(name: Notification.Name("skipP1"), object: nil)
            }
            if(self.myGameData.user0GiveUp == false && self.myGameData.user1Skipped == false) {
                NotificationCenter.default.post(name: Notification.Name("gn"), object: nil)
            }
            
            //GIVEUP
            if(self.myGameData.user0GiveUp) {
                NotificationCenter.default.post(name: Notification.Name("giveupP0"), object: nil)
            }
            if(self.myGameData.user1GiveUp) {
                NotificationCenter.default.post(name: Notification.Name("giveupP1"), object: nil)
            }
            
            //SKIP & GAME OVER RULE
            if(self.myGameData.user0Skipped && self.myGameData.user1Skipped) {
                NotificationCenter.default.post(name: Notification.Name("gameOver"), object: nil)
            }
            if(self.myGameData.nowPlayer == 0 && self.myGameData.user0Skipped) {
                NotificationCenter.default.post(name: Notification.Name("skipP0"), object: nil)
            }
            if(self.myGameData.nowPlayer == 1 && self.myGameData.user1Skipped) {
                NotificationCenter.default.post(name: Notification.Name("skipP1"), object: nil)
            }
            
        }
            
    }
    
    //input userNum is winner
    //計算勝率＆計算金幣加減(Winner+50 Loser-50)
    func countWinandLose(user: Int) -> Void {
        print("Count")
        print(self.myGameData.roomData.user0.userID ?? "")
        print(self.myGameData.roomData.user1.userID ?? "")
        print(self.myGameData.roomData.user2.userID ?? "")
        print(self.myGameData.roomData.user3.userID ?? "")
        if user == 0 {
            //print(self.myGameData.roomData.user0.userWin, self.myGameData.roomData.user1.userWin)
            self.myGameData.roomData.user0.userWin += 1
            self.myGameData.roomData.user1.userLose += 1
            self.myGameData.roomData.user2.userLose += 1
            self.myGameData.roomData.user3.userLose += 1
            self.myGameData.roomData.user0.userMoney += 50
            self.myGameData.roomData.user1.userMoney -= 50
            self.myGameData.roomData.user2.userMoney -= 50
            self.myGameData.roomData.user3.userMoney -= 50
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userWin": self.myGameData.roomData.user0.userWin], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userLose": self.myGameData.roomData.user1.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userLose": self.myGameData.roomData.user2.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userLose": self.myGameData.roomData.user3.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userMoney": self.myGameData.roomData.user0.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userMoney": self.myGameData.roomData.user1.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userMoney": self.myGameData.roomData.user2.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userMoney": self.myGameData.roomData.user3.userMoney], merge: true)
        } else if user == 1{
            self.myGameData.roomData.user0.userLose += 1
            self.myGameData.roomData.user1.userWin += 1
            self.myGameData.roomData.user2.userLose += 1
            self.myGameData.roomData.user3.userLose += 1
            self.myGameData.roomData.user0.userMoney -= 50
            self.myGameData.roomData.user1.userMoney += 50
            self.myGameData.roomData.user2.userMoney -= 50
            self.myGameData.roomData.user3.userMoney -= 50
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userLose": self.myGameData.roomData.user0.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userWin": self.myGameData.roomData.user1.userWin], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userLose": self.myGameData.roomData.user2.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userLose": self.myGameData.roomData.user3.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userMoney": self.myGameData.roomData.user0.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userMoney": self.myGameData.roomData.user1.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userMoney": self.myGameData.roomData.user2.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userMoney": self.myGameData.roomData.user3.userMoney], merge: true)
        } else if user == 2{
            self.myGameData.roomData.user0.userLose += 1
            self.myGameData.roomData.user1.userLose += 1
            self.myGameData.roomData.user2.userWin += 1
            self.myGameData.roomData.user3.userLose += 1
            self.myGameData.roomData.user0.userMoney -= 50
            self.myGameData.roomData.user1.userMoney -= 50
            self.myGameData.roomData.user2.userMoney += 50
            self.myGameData.roomData.user3.userMoney -= 50
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userLose": self.myGameData.roomData.user0.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userLose": self.myGameData.roomData.user1.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userWin": self.myGameData.roomData.user2.userWin], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userLose": self.myGameData.roomData.user3.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userMoney": self.myGameData.roomData.user0.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userMoney": self.myGameData.roomData.user1.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userMoney": self.myGameData.roomData.user2.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userMoney": self.myGameData.roomData.user3.userMoney], merge: true)
        } else if user == 3{
            self.myGameData.roomData.user0.userLose += 1
            self.myGameData.roomData.user1.userLose += 1
            self.myGameData.roomData.user2.userLose += 1
            self.myGameData.roomData.user3.userWin += 1
            self.myGameData.roomData.user0.userMoney -= 50
            self.myGameData.roomData.user1.userMoney -= 50
            self.myGameData.roomData.user2.userMoney -= 50
            self.myGameData.roomData.user3.userMoney += 50
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userLose": self.myGameData.roomData.user0.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userLose": self.myGameData.roomData.user1.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userLose": self.myGameData.roomData.user2.userLose], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userWin": self.myGameData.roomData.user3.userWin], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user0.userID ?? "").setData(["userMoney": self.myGameData.roomData.user0.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user1.userID ?? "").setData(["userMoney": self.myGameData.roomData.user1.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user2.userID ?? "").setData(["userMoney": self.myGameData.roomData.user2.userMoney], merge: true)
            self.db.collection("Users_Data").document(self.myGameData.roomData.user3.userID ?? "").setData(["userMoney": self.myGameData.roomData.user3.userMoney], merge: true)
        }
    }
    
    func removeGameListener() -> Void {
        self.listener?.remove()
    }
    
    func delGameRoom() -> Void {
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").delete() { err in
            if let err = err {
                print("Error removing room: \(err)")
            } else {
                print("Room successfully deleted!")
            }
        }
    }
    
    func turnPlayer(nowPlayer: Int) -> Void {
        if nowPlayer == 0 {
            self.myGameData.nowPlayer = 1
            self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["nowPlayer": 1], merge: true)
            print("Change to Player2")
        } else if nowPlayer == 1 {
            self.myGameData.nowPlayer = 2
            self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["nowPlayer": 2], merge: true)
            print("Change to Player3")
        }
        else if nowPlayer == 2{
            self.myGameData.nowPlayer = 3
            self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["nowPlayer": 3], merge: true)
            print("Change to Player4")
        }
        else if nowPlayer == 3{
            self.myGameData.nowPlayer = 0
            self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["nowPlayer": 0], merge: true)
            print("Change to Player1")
        }
    }
    
    //update checkerboard (index1, index2)為下的地方
    
    /*var dice_1 = 1
     var dice_2 = 2
     var player0_offset = [-150, -160,0,0]
     var player1_offset = [-120, -160,0,0]
     var player2_offset = [-150, -130,0,0]
     var player3_offset = [-120, -130,0,0]
     var player0_money: Int = 10000
     var player1_money: Int = 10000
     var player2_money: Int = 10000
     var player3_money: Int = 10000*/
    
    func setGiveUp() -> Void {
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["userGiveUp": self.myGameData.userGiveUp], merge: true)
    }
    
    func setisFinal(status: Bool, user: Int) -> Void {
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["user" + String(user) + "Skipped": status], merge: true)
    }
    
    func update_db(){
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["monopoly_color": self.myGameData.monopoly_color], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["checkerboard": self.myGameData.checkerboard], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player0_money": self.myGameData.player0_money], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player1_money": self.myGameData.player1_money], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player2_money": self.myGameData.player2_money], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player3_money": self.myGameData.player3_money], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player_jail": self.myGameData.player_jail], merge: true)
        
    }
    
    func update_offset(){
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player0_offset": self.myGameData.player0_offset], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player1_offset": self.myGameData.player1_offset], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player2_offset": self.myGameData.player2_offset], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["player3_offset": self.myGameData.player3_offset], merge: true)
    }
    
    func update_dices(){
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["dice_1": self.myGameData.dice_1], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["dice_2": self.myGameData.dice_2], merge: true)
    }
    
    func update_pay(){
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["getmoney": self.myGameData.getmoney], merge: true)
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["submoney": self.myGameData.submoney], merge: true)
    }
    
    func update_out_alert(){
        self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").setData(["out_alert": self.myGameData.out_alert], merge: true)
    }
    
}

struct GameData: Codable, Identifiable {
    @DocumentID var id: String?
    var roomData: RoomData
    var nowPlayer: Int
    var user0Skipped: Bool = false
    var user1Skipped: Bool = false
    var user0GiveUp: Bool = false
    var user1GiveUp: Bool = false
    var user2GiveUp: Bool = false
    var user3GiveUp: Bool = false
    var userGiveUp = [false, false, false, false]
    var getmoney = [false, false, false, false]
    var submoney = [false, false, false, false]
    var out_alert = [false, false, false, false]
    //-1代表不能下 0代表當前player可下位置 1代表Player1的棋子 2代表Player2的棋子
    var checkerboard = ["0": [-1, -1, -1, -1, -1, -1, -1, -1],
                        "1": [-1, -1, -1, -1, -1, -1, -1, -1],
                        "2": [-1, -1, -1,  0, -1, -1, -1, -1],
                        "3": [-1, -1,  0,  2,  1, -1, -1, -1],
                        "4": [-1, -1, -1,  1,  2,  0, -1, -1],
                        "5": [-1, -1, -1, -1,  0, -1, -1, -1],
                        "6": [-1, -1, -1, -1, -1, -1, -1, -1],
                        "7": [-1, -1, -1, -1, -1, -1, -1, -1]]
    //var monopoly_color:[[Color]] = Array(repeating: Array(repeating: Color.clear, count: 6), count: 6)
    //var monopoly:[[monopoly_grid]] = Array(repeating: Array(repeating: monopoly_grid(), count: 6), count: 6)
    var dice_1 = 1
    var dice_2 = 2
    var player0_offset = [-150, -160,0,0]
    var player1_offset = [-120, -160,0,0]
    var player2_offset = [-150, -130,0,0]
    var player3_offset = [-120, -130,0,0]
    var player0_money: Int = 10000
    var player1_money: Int = 10000
    var player2_money: Int = 10000
    var player3_money: Int = 10000
    var player_jail = [false, false, false, false]
    var monopoly_color = ["0": [0, 0, 0, 0, 0, 0],
                          "1": [0, 0, 0, 0, 0, 0],
                          "2": [0, 0, 0, 0, 0, 0],
                          "3": [0, 0, 0, 0, 0, 0],
                          "4": [0, 0, 0, 0, 0, 0],
                          "5": [0, 0, 0, 0, 0, 0]]
    var rotateDegree = ["0": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "1": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "2": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "3": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "4": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "5": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "6": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
                        "7": [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
    
}
