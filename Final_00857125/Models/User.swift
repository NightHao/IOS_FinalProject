//
//  User.swift
//  Final_00857125
//
//  Created by nighthao on 2022/5/29.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class MyUserData: ObservableObject {
    @Published var currentUser: User?
    @Published var currentUserData: UserData
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    init() {
        self.currentUser = Auth.auth().currentUser
        self.currentUserData = UserData(id: "", userID: "", userName: "", userPhotoURL: "", userGender: "", userBD: "", userFirstLogin: "", userCountry: "")
    }
    func addUserListener() -> Void {
        self.listener = self.db.collection("users_data").document(self.currentUser?.uid ?? "").addSnapshotListener{
            snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: UserData.self) else { return }
            self.copyUser(userData: user)
            print("User data update!")
            
        }
    }
    
    func removeUserListener() -> Void {
        self.listener?.remove()
    }
    
    func copyUser(userData: UserData) -> Void {
        self.currentUserData = userData
    }
}

struct UserData: Codable, Identifiable {
    @DocumentID var id: String?
    let userID: String?
    let userName: String
    let userPhotoURL: String
    let userGender: String
    let userBD: String
    let userFirstLogin: String
    let userCountry: String
    var userWin: Int = 0
    var userLose: Int = 0
    var userMoney: Int = 1000
}
