//
//  Room.swift
//  Final_00857125
//
//  Created by nighthao on 2022/6/7.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class MyRoom: ObservableObject {
    @Published var roomData: RoomData
    private var listener: ListenerRegistration?
    let roomReady = NotificationCenter.default.publisher(for: Notification.Name("roomReady"))
    let changeHost = NotificationCenter.default.publisher(for: Notification.Name("cgHost"))
    let noSecondPlayer = NotificationCenter.default.publisher(for: Notification.Name("noSecPlayer"))
    let secondPlayerInto = NotificationCenter.default.publisher(for: Notification.Name("secPlayerInto"))
    let noThirdPlayer = NotificationCenter.default.publisher(for: Notification.Name("noThirdPlayer"))
    let thirdPlayerInto = NotificationCenter.default.publisher(for: Notification.Name("thirdPlayerInto"))
    let noFourthPlayer = NotificationCenter.default.publisher(for: Notification.Name("noFourthPlayer"))
    let fourthPlayerInto = NotificationCenter.default.publisher(for: Notification.Name("fourthPlayerInto"))
    let db = Firestore.firestore()
    init() {
        self.roomData = RoomData(id: "", user0: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user0ready: false, user1: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user1ready: false, user2: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user2ready: false, user3: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user3ready: false, roundTime: 0, roomPassWord: "", startPlayer: 0, roomGameStatus: false)
    }
    func copyRoom(newRoom: RoomData) -> Void {
        self.roomData = newRoom
    }
    func addRoomListener() -> Void {
        self.listener = self.db.collection("game_room").document(self.roomData.id ?? "").addSnapshotListener{
            snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let room = try? snapshot.data(as: RoomData.self) else { return }
            self.copyRoom(newRoom: room)
            print("Room data update!")
            if(self.roomData.user1.userName != "") {
                print("二號玩家進來")
                NotificationCenter.default.post(name: Notification.Name("secPlayerInto"), object: nil)
            }
            if(self.roomData.user2.userName != "") {
                print("三號玩家進來")
                NotificationCenter.default.post(name: Notification.Name("thirdPlayerInto"), object: nil)
            }
            if(self.roomData.user3.userName != "") {
                print("四號玩家進來")
                NotificationCenter.default.post(name: Notification.Name("fourthPlayerInto"), object: nil)
            }
            if(self.roomData.user0ready && self.roomData.user1ready && self.roomData.user2ready && self.roomData.user3ready){
                NotificationCenter.default.post(name: Notification.Name("roomReady"), object: nil)
            }
            if(self.roomData.user1.userName == "") {
                print("二號玩家尚未加入")
                NotificationCenter.default.post(name: Notification.Name("noSecPlayer"), object: nil)
            }
            if(self.roomData.user2.userName == "") {
                print("三號玩家尚未加入")
                NotificationCenter.default.post(name: Notification.Name("noThirdPlayer"), object: nil)
            }
            if(self.roomData.user3.userName == "") {
                print("四號玩家尚未加入")
                NotificationCenter.default.post(name: Notification.Name("noFourthPlayer"), object: nil)
            }
            if(self.roomData.user0.userName == self.roomData.user1.userName) {
                print("主持人離開，換新主持人")
                NotificationCenter.default.post(name: Notification.Name("cgHost"), object: nil)
            }
        }
    }
    func removeRoomListener() -> Void {
        self.listener?.remove()
    }
    func getReady(userNum: Int) -> Void {
        if userNum == 0 {
            self.roomData.user0ready = true
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user0ready": true], merge: true)
            print("1號玩家準備完畢")
        } else if userNum == 1 {
            self.roomData.user1ready = true
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1ready": true], merge: true)
            print("2號玩家準備完畢")
        } else if userNum == 2 {
            self.roomData.user2ready = true
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user2ready": true], merge: true)
            print("3號玩家準備完畢")
        } else if userNum == 3 {
            self.roomData.user3ready = true
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user3ready": true], merge: true)
            print("4號玩家準備完畢")
        }
    }
    
    func cancelReady(userNum: Int) -> Void {
        if userNum == 0 {
            print("1號玩家取消準備")
            self.roomData.user0ready = false
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user0ready": false], merge: true)
        } else if userNum == 1 {
            self.roomData.user1ready = false
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1ready": false], merge: true)
            print("2號玩家取消準備")
        } else if userNum == 2 {
            self.roomData.user2ready = false
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user2ready": false], merge: true)
            print("3號玩家取消準備")
        } else if userNum == 3 {
            self.roomData.user3ready = false
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user3ready": false], merge: true)
            print("4號玩家取消準備")
        }
    }
    
    func setRoomGameStatus(status: Bool) -> Void {
        self.db.collection("game_room").document(self.roomData.id ?? "").setData(["roomGameStatus": status], merge: true)
    }
    
    func delRoom() -> Void {
        self.db.collection("game_room").document(self.roomData.id ?? "").delete() { err in
            if let err = err {
                print("Error removing room: \(err)")
            } else {
                print("Room successfully deleted!")
            }
        }
    }
    
    func leaveRoom(userNum: Int) -> Void {
        let userNull: [String: Any] = [
            "userBD": "",
            "userCountry": "",
            "userFirstLogin": "",
            "userGender": "",
            "userID": "",
            "userLose": 0,
            "userName": "",
            "userPhotoURL": "",
            "userWin": 0
        ]
        let newHost: [String: Any] = [
            "userBD": self.roomData.user1.userBD,
            "userCountry": self.roomData.user1.userCountry,
            "userFirstLogin": self.roomData.user1.userFirstLogin,
            "userGender": self.roomData.user1.userGender,
            "userID": self.roomData.user1.userID ?? "",
            "userLose": self.roomData.user1.userLose,
            "userName": self.roomData.user1.userName,
            "userPhotoURL": self.roomData.user1.userPhotoURL,
            "userWin": self.roomData.user1.userWin
        ]
        if userNum == 0 {
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user0": newHost], merge: true)
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1": userNull], merge: true)
        } else if userNum == 1 {
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1": userNull], merge: true)
        }
    }
    
    func selectStartPlayer() -> Void {
        let randomPlayer = Int.random(in: 0...3)
        self.db.collection("game_room").document(self.roomData.id ?? "").setData(["startPlayer": randomPlayer], merge: true)
    }
}

class MyRoomList: ObservableObject {
    @Published var roomList: [RoomData]
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    init() {
        roomList = [RoomData(id: "", user0: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user0ready: false, user1: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user1ready: false, user2: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user2ready: false, user3: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user3ready: false, roundTime: 0, roomPassWord: "", startPlayer: 0, roomGameStatus: false)]
    }
    
    func updateRoomList() -> Void {
        FireBase.shared.fetchRooms { result in
            switch result {
            case .success(let rArray):
                self.roomList = rArray
            case .failure(_):
                print("Update Room List Failed.")
            }
        }
    }
    
}

struct RoomData: Codable, Identifiable {
    @DocumentID var id: String?
    var user0: UserData
    var user0ready: Bool
    var user1: UserData
    var user1ready: Bool
    var user2: UserData
    var user2ready: Bool
    var user3: UserData
    var user3ready: Bool
    var roundTime: Int
    var roomPassWord: String
    var startPlayer: Int
    var roomGameStatus: Bool
}

/*import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class MyRoom: ObservableObject {
    @Published var roomData: RoomData
    private var listener: ListenerRegistration?
    let roomReady = NotificationCenter.default.publisher(for: Notification.Name("roomReady"))
    let changeHost = NotificationCenter.default.publisher(for: Notification.Name("cgHost"))
    let noSecondPlayer = NotificationCenter.default.publisher(for: Notification.Name("noSecPlayer"))
    let secondPlayerInto = NotificationCenter.default.publisher(for: Notification.Name("secPlayerInto"))
    let db = Firestore.firestore()
    init() {
        self.roomData = RoomData(id: "", user0: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user0ready: false, user1: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user1ready: false, roundTime: 0, roomPassWord: "", startPlayer: 0, roomGameStatus: false)
    }
    func copyRoom(newRoom: RoomData) -> Void {
        self.roomData = newRoom
    }
    func addRoomListener() -> Void {
        self.listener = self.db.collection("game_room").document(self.roomData.id ?? "").addSnapshotListener{
            snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let room = try? snapshot.data(as: RoomData.self) else { return }
            self.copyRoom(newRoom: room)
            print("Room data update!")
            if(self.roomData.user1.userName != "") {
                print("二號玩家進來")
                NotificationCenter.default.post(name: Notification.Name("secPlayerInto"), object: nil)
            }
            if(self.roomData.user0ready && self.roomData.user1ready){
                NotificationCenter.default.post(name: Notification.Name("roomReady"), object: nil)
            }
            if(self.roomData.user1.userName == "") {
                print("二號玩家尚未加入")
                NotificationCenter.default.post(name: Notification.Name("noSecPlayer"), object: nil)
            }
            if(self.roomData.user0.userName == self.roomData.user1.userName) {
                print("主持人離開，換新主持人")
                NotificationCenter.default.post(name: Notification.Name("cgHost"), object: nil)
            }
        }
    }
    func removeRoomListener() -> Void {
        self.listener?.remove()
    }
    func getReady(userNum: Int) -> Void {
        if userNum == 0 {
            self.roomData.user0ready = true
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user0ready": true], merge: true)
            print("1號玩家準備完畢")
        } else if userNum == 1 {
            self.roomData.user1ready = true
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1ready": true], merge: true)
            print("2號玩家準備完畢")
        }
    }
    
    func cancelReady(userNum: Int) -> Void {
        if userNum == 0 {
            print("1號玩家取消準備")
            self.roomData.user0ready = false
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user0ready": false], merge: true)
        } else if userNum == 1 {
            self.roomData.user1ready = false
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1ready": false], merge: true)
            print("2號玩家取消準備")
        }
    }
    
    func setRoomGameStatus(status: Bool) -> Void {
        self.db.collection("game_room").document(self.roomData.id ?? "").setData(["roomGameStatus": status], merge: true)
    }
    
    func delRoom() -> Void {
        self.db.collection("game_room").document(self.roomData.id ?? "").delete() { err in
            if let err = err {
                print("Error removing room: \(err)")
            } else {
                print("Room successfully deleted!")
            }
        }
    }
    
    func leaveRoom(userNum: Int) -> Void {
        let userNull: [String: Any] = [
            "userBD": "",
            "userCountry": "",
            "userFirstLogin": "",
            "userGender": "",
            "userID": "",
            "userLose": 0,
            "userName": "",
            "userPhotoURL": "",
            "userWin": 0
        ]
        let newHost: [String: Any] = [
            "userBD": self.roomData.user1.userBD,
            "userCountry": self.roomData.user1.userCountry,
            "userFirstLogin": self.roomData.user1.userFirstLogin,
            "userGender": self.roomData.user1.userGender,
            "userID": self.roomData.user1.userID ?? "",
            "userLose": self.roomData.user1.userLose,
            "userName": self.roomData.user1.userName,
            "userPhotoURL": self.roomData.user1.userPhotoURL,
            "userWin": self.roomData.user1.userWin
        ]
        if userNum == 0 {
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user0": newHost], merge: true)
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1": userNull], merge: true)
        } else if userNum == 1 {
            self.db.collection("game_room").document(self.roomData.id ?? "").setData(["user1": userNull], merge: true)
        }
    }
    
    func selectStartPlayer() -> Void {
        let randomPlayer = Int.random(in: 0...1)
        self.db.collection("game_room").document(self.roomData.id ?? "").setData(["startPlayer": randomPlayer], merge: true)
    }
}

class MyRoomList: ObservableObject {
    @Published var roomList: [RoomData]
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    init() {
        roomList = [RoomData(id: "", user0: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user0ready: false, user1: UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: ""), user1ready: false, roundTime: 0, roomPassWord: "", startPlayer: 0, roomGameStatus: false)]
    }
    
    func updateRoomList() -> Void {
        FireBase.shared.fetchRooms { result in
            switch result {
            case .success(let rArray):
                self.roomList = rArray
            case .failure(_):
                print("Update Room List Failed.")
            }
        }
    }
    
}

struct RoomData: Codable, Identifiable {
    @DocumentID var id: String?
    var user0: UserData
    var user0ready: Bool
    var user1: UserData
    var user1ready: Bool
    var roundTime: Int
    var roomPassWord: String
    var startPlayer: Int
    var roomGameStatus: Bool
}
*/
